module ActiveRecord
  module Associations
    class CountLoader < SingularAssociation
      # Not preloaded behaviour of count_loader association
      # When this method is called, it will be N+1 query
      def load_target
        count_target = reflection.name.to_s.sub(/_count\z/, '').to_sym
        @target = owner.association(count_target).size

        loaded! unless loaded?
        target
      rescue ActiveRecord::RecordNotFound
        reset
      end
    end
  end

  module Reflection
    class CountLoaderReflection < AssociationReflection
      def macro; :count_loader; end

      def association_class
        ActiveRecord::Associations::CountLoader
      end

      def klass
        @klass ||= active_record.send(:compute_type, options[:class_name] || name.to_s.sub(/_count\z/, '').singularize.classify)
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
            super
          end
        end
      end
    end
  end

  Reflection.prepend(Precount::ReflectionExtension)
end
