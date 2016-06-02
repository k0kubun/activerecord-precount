module ActiveRecord
  module Precount
    class CountLoaderBuilder
      def initialize(model)
        @model = model
      end

      def build(name, scope, options)
        name_with_count =
          if options[:count_loader].is_a?(Symbol)
            options[:count_loader]
          else
            :"#{name}_count"
          end

        valid_options = options.slice(*Associations::Builder::CountLoader.valid_options)
        reflection = Associations::Builder::CountLoader.build(@model, name_with_count, scope, valid_options)
        Reflection.add_reflection(@model, name_with_count, reflection)
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
