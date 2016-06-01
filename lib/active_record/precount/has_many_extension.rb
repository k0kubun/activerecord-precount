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
      module HasManyExtension
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
    end
  end

  Associations::Builder::HasMany.prepend(Precount::Builder::HasManyExtension)
end
