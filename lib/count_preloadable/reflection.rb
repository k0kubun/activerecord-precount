require "active_record/associations/count_preloadable_association"

module CountPreloadable
  module Reflection
    def create_with_count_preloadable(macro, name, scope, options, ar)
      case macro
      when :count_preloadable
        ActiveRecord::Reflection::AssociationReflection.new(macro, name, scope, options, ar)
      else
        create_without_count_preloadable(macro, name, scope, options, ar)
      end
    end

    module AssociationReflection
      def association_class_with_count_preloadable
        case macro
        when :count_preloadable
          ActiveRecord::Associations::CountPreloadableAssociation
        else
          association_class_without_count_preloadable
        end
      end
    end
  end
end
