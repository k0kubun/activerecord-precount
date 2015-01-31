module ActiveRecord
  module CountLoader
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

      private

      def define_count_loader!(*args)
        args.each do |arg|
          raise ArgumentError, "#{klass} does not have :#{arg} association." unless has_reflection?(arg.to_s)
          next if klass.reflections.keys.include?(counter_name = "#{arg}_count")

          options = reflections[arg.to_s].options.slice(*Associations::Builder::CountLoader.valid_options)
          reflection = Associations::Builder::CountLoader.build(klass, counter_name.to_sym, nil, options)
          Reflection.add_reflection(model, counter_name, reflection)
        end
      end

      def has_reflection?(name)
        reflections.keys.include?(name)
      end
    end
  end
end
