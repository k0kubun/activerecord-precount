module ActiveRecord
  module Reflection
    class CountLoaderReflection < AssociationReflection
      def initialize(name, scope, options, active_record)
        super(name, scope, options, active_record)
      end

      def macro; :count_loader; end
    end
  end

  module Associations
    class CountLoader < SingularAssociation
      # Not preloaded behaviour of count_loader association
      # When this method is called, it will be N+1 query
      def load_target
        count_target = reflection.name_without_count.to_sym
        @target = owner.association(count_target).count

        loaded! unless loaded?
        target
      rescue ActiveRecord::RecordNotFound
        reset
      end
    end
  end

  module Precount
    module ReflectionExtension
      def self.prepended(base)
        class << base
          prepend ClassMethods
        end
      end

      module ClassMethods
        def create(macro, name, scope, options, ar)
          case macro
          when :count_loader
            Reflection::CountLoaderReflection.new(name, scope, options, ar)
          else
            super(macro, name, scope, options, ar)
          end
        end
      end
    end

    module AssociationReflectionExtension
      def klass
        case macro
        when :count_loader
          @klass ||= active_record.send(:compute_type, options[:class_name] || name_without_count.singularize.classify)
        else
          super
        end
      end

      def name_without_count
        name.to_s.sub(/_count$/, "")
      end

      def association_class
        case macro
        when :count_loader
          ActiveRecord::Associations::CountLoader
        else
          super
        end
      end
    end
  end

  Reflection.prepend(Precount::ReflectionExtension)
  Reflection::AssociationReflection.prepend(Precount::AssociationReflectionExtension)
end
