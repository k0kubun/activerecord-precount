require "active_record/associations/builder/count_preloadable"
require "active_record/associations/count_preloadable_association"

module ActiveRecord
  module Associations
    module ClassMethods
      def count_preloadable(name, scope = nil, options = {}, &extension)
        name = :"#{name}_count"

        reflection = Builder::CountPreloadable.build(self, name, scope, options, &extension)
        Reflection.add_reflection(self, name, reflection)
      end
    end
  end
end

module ActiveRecord
  module Reflection
    class << self
      def create_with_count_preloadable(macro, name, scope, options, ar)
        case macro
        when :count_preloadable
          AssociationReflection.new(macro, name, scope, options, ar)
        else
          create_without_count_preloadable(macro, name, scope, options, ar)
        end
      end
      alias_method_chain :create, :count_preloadable
    end

    class AssociationReflection
      def association_class_with_count_preloadable
        case macro
        when :count_preloadable
          Associations::CountPreloadableAssociation
        else
          association_class_without_count_preloadable
        end
      end
      alias_method_chain :association_class, :count_preloadable
    end
  end
end
