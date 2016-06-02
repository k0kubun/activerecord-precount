module ActiveRecord
  module Associations
    class CountLoader < SingularAssociation
      # Not preloaded behaviour of count_loader association
      # When this method is called, it will be N+1 query
      def load_target
        count_target = reflection.name.to_s.sub(/_count\z/, '').to_sym
        @target = owner.association(count_target).count

        loaded! unless loaded?
        target
      rescue ActiveRecord::RecordNotFound
        reset
      end
    end
  end

  module Precount
    module AssociationReflectionExtension
      def klass
        case macro
        when :count_loader
          @klass ||= active_record.send(:compute_type, options[:class_name] || name.to_s.sub(/_count\z/, '').singularize.classify)
        else
          super
        end
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

  Reflection::AssociationReflection.prepend(Precount::AssociationReflectionExtension)
end
