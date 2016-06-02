require 'active_record/precount/reflection_checker'

module ActiveRecord
  module Precount
    class CountLoaderBuilder
      def initialize(model)
        @model = model
      end

      def build_from_has_many(name, scope, options)
        name_with_count =
          if options[:count_loader].is_a?(Symbol)
            options[:count_loader]
          else
            :"#{name}_count"
          end

        add_reflection(name_with_count, scope, options)
      end

      def build_from_query_methods(*args)
        args.each do |arg|
          next if ReflectionChecker.has_reflection?(@model, counter_name = :"#{arg}_count")
          unless ReflectionChecker.has_reflection?(@model, arg)
            raise ArgumentError, "Association named '#{arg}' was not found on #{@model.name}."
          end

          original_reflection = @model.reflections[arg.to_s]
          add_reflection(counter_name, original_reflection.scope, original_reflection.options)
        end
      end

      private

      def add_reflection(name, scope, options)
        valid_options = options.slice(*Associations::Builder::CountLoader.valid_options)
        reflection = Associations::Builder::CountLoader.build(@model, name, scope, valid_options)
        Reflection.add_reflection(@model, name, reflection)
      end
    end
  end

  module Associations
    module Builder
      class CountLoader < SingularAssociation
        def self.valid_options(*)
          [:class, :class_name, :foreign_key]
        end

        if ActiveRecord.version.segments.first >= 5
          def self.macro
            :count_loader
          end
        else
          def macro
            :count_loader
          end
        end

        def self.valid_dependent_options
          []
        end
      end
    end
  end
end
