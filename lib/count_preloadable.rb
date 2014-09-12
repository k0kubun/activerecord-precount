require "active_record/associations/builder/count_preloadable"
module ActiveRecord
  module Associations
    module ClassMethods
      def count_preloadable(name, scope = nil, options = {}, &extension)
        name_with_count = :"#{name}_count"

        reflection = Builder::CountPreloadable.build(self, name_with_count, scope, options, &extension)
        Reflection.add_reflection(self, name_with_count, reflection)
      end
    end
  end
end

require "active_record/associations/count_preloadable_association"
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

require "active_record/associations/preloader/count_preloadable"
module ActiveRecord
  module Associations
    class Preloader
      private

      def preloader_for_with_count_preloadable(reflection, owners, rhs_klass)
        preloader = preloader_for_without_count_preloadable(reflection, owners, rhs_klass)
        return preloader if preloader

        case reflection.macro
        when :count_preloadable
          CountPreloadable
        end
      end
      alias_method_chain :preloader_for, :count_preloadable
    end
  end
end

module ActiveRecord
  # This imitates EagerLoadPolymorphicError
  class EagerLoadCountPreloadableError < ActiveRecordError
    def initialize(reflection)
      super("Cannot eagerly load the count_preloadable association #{reflection.name.inspect}")
    end
  end

  module Associations
    class JoinDependency
      def build_with_count_preloadable(associations, base_klass)
        associations.map do |name, right|
          reflection = find_reflection base_klass, name
          if reflection.macro == :count_preloadable
            raise EagerLoadCountPreloadableError.new(reflection)
          end
        end

        build_without_count_preloadable(associations, base_klass)
      end
      alias_method_chain :build, :count_preloadable
    end
  end
end
