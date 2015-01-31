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
          raise ArgumentError, "#{klass} does not have :#{arg} association." unless has_reflection?(arg)
          next if has_reflection?(counter_name = :"#{arg}_count")

          options = reflection_for(arg).options.slice(*Associations::Builder::CountLoader.valid_options)
          reflection = Associations::Builder::CountLoader.build(klass, counter_name, nil, options)
          Reflection.add_reflection(model, counter_name, reflection)
        end
      end

      def has_reflection?(name)
        reflection_for(name).present?
      end

      def reflection_for(name)
        if ActiveRecord::VERSION::MAJOR >= 4 && ActiveRecord::VERSION::MINOR >= 2
          reflections[name.to_s]
        else
          reflections[name.to_sym]
        end
      end
    end
  end
end
