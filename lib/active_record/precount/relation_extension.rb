require 'active_record/precount/count_loader_builder'

module ActiveRecord
  module Precount
    module RelationExtension
      def precount(*args)
        check_if_method_has_arguments!(:precount, args)
        spawn.precount!(*args)
      end

      def precount!(*args)
        CountLoaderBuilder.new(klass).build_from_query_methods(*args)

        self.preload_values += args.map { |arg| :"#{arg}_count" }
        self
      end

      def eager_count(*args)
        check_if_method_has_arguments!(:eager_count, args)
        spawn.eager_count!(*args)
      end

      def eager_count!(*args)
        CountLoaderBuilder.new(klass).build_from_query_methods(*args)

        self.eager_load_values += args.map { |arg| :"#{arg}_count" }
        self
      end

      private

      def apply_join_dependency(relation, join_dependency)
        relation = super

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
