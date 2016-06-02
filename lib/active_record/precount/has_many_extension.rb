module ActiveRecord
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

  module Precount
    module Builder
      module Rails4HasManyExtension
        def valid_options
          super + [:count_loader]
        end

        def build(model)
          define_count_loader(model) if options[:count_loader]
          super
        end

        def define_count_loader(model)
          name_with_count = :"#{name}_count"
          name_with_count = options[:count_loader] if options[:count_loader].is_a?(Symbol)

          valid_options = options.slice(*Associations::Builder::CountLoader.valid_options)
          reflection = Associations::Builder::CountLoader.build(model, name_with_count, scope, valid_options)
          Reflection.add_reflection(model, name_with_count, reflection)
        end
      end

      module Rails5HasManyExtension
        def valid_options(*)
          super + [:count_loader]
        end

        def build(model, name, scope, options, &block)
          if scope.is_a?(Hash)
            options = scope
            scope   = nil
          end

          if options[:count_loader]
            name_with_count = :"#{name}_count"
            name_with_count = options[:count_loader] if options[:count_loader].is_a?(Symbol)

            valid_options = options.slice(*Associations::Builder::CountLoader.valid_options)
            reflection = Associations::Builder::CountLoader.build(model, name_with_count, scope, valid_options)
            Reflection.add_reflection(model, name_with_count, reflection)
          end
          super
        end
      end
    end
  end

  if ActiveRecord.version.segments.first >= 5
    Associations::Builder::HasMany.extend(Precount::Builder::Rails5HasManyExtension)
  else
    Associations::Builder::HasMany.prepend(Precount::Builder::Rails4HasManyExtension)
  end
end
