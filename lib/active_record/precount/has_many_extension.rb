module ActiveRecord
  module Associations
    module Builder
      class CountLoader < SingularAssociation
        def self.valid_options
          [:class, :class_name, :foreign_key]
        end

        def macro
          :count_loader
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
          super
          if scope.is_a?(Hash)
            options = scope
            scope = nil
          end
          define_count_loader(model, name, scope, options) if options[:count_loader]
        end

        def define_count_loader(model, name, scope, options)
          name_with_count = :"#{name}_count"
          name_with_count = options[:count_loader] if options[:count_loader].is_a?(Symbol)

          valid_options = options.slice(*Associations::Builder::CountLoader.valid_options)
          reflection = Associations::Builder::CountLoader.build(model, name_with_count, scope, valid_options)
          Reflection.add_reflection(model, name_with_count, reflection)
        end
      end
    end
  end

  if ActiveRecord.version.segments.first >= 5
    Associations::Builder::HasMany.send(:extend, Precount::Builder::Rails5HasManyExtension)
  else
    Associations::Builder::HasMany.send(:extend, Precount::Builder::Rails4HasManyExtension)
  end
end
