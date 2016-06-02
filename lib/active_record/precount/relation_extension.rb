module ActiveRecord
  module Precount
    module RelationExtension
      def precount(*args)
        check_if_method_has_arguments!(:precount, args)
        spawn.precount!(*args)
      end

      def precount!(*args)
        define_count_loader!(*args)

        self.preload_values += args.map { |arg| :"#{arg}_count" }
        self
      end

      def eager_count(*args)
        check_if_method_has_arguments!(:eager_count, args)
        spawn.eager_count!(*args)
      end

      def eager_count!(*args)
        define_count_loader!(*args)

        self.eager_load_values += args.map { |arg| :"#{arg}_count" }
        self
      end

      private

      def define_count_loader!(*args)
        args.each do |arg|
          raise ArgumentError, "Association named '#{arg}' was not found on #{klass.name}." unless has_reflection?(arg)
          next if has_reflection?(counter_name = :"#{arg}_count")

          original_reflection = reflection_for(arg)
          scope = original_reflection.scope
          options = original_reflection.options.slice(*Associations::Builder::CountLoader.valid_options)
          reflection = Associations::Builder::CountLoader.build(klass, counter_name, scope, options)
          Reflection.add_reflection(model, counter_name, reflection)
        end
      end

      def apply_join_dependency(relation, join_dependency)
        relation = super(relation, join_dependency)

        # to count associated records in JOIN query, group scope is necessary
        join_dependency.reflections.each do |reflection|
          if reflection.macro == :count_loader
            ar = reflection.active_record
            relation = relation.group("#{ar.table_name}.#{ar.primary_key}")
          end
        end

        relation
      end
    end
  end

  Relation.prepend(Precount::RelationExtension)
end
