module ActiveRecord
  module Associations
    module ClassMethods
      module HasCount
        private

        def has_count(name, scope = nil, options = {}, &extension)
          name_with_count = :"#{name}_count"

          reflection = Builder::HasCount.build(self, name_with_count, scope, options, &extension)
          Reflection.add_reflection(self, name_with_count, reflection)
        end
      end
    end

    class HasCount < SingularAssociation
      # Not preloaded behaviour of count_preloadable association
      # When this method is called, it will be N+1 query
      def load_target
        count_target = name_without_count.to_sym
        @target = owner.association(count_target).count

        loaded! unless loaded?
        target
      rescue ActiveRecord::RecordNotFound
        reset
      end

      # This method is used by preloader when grouping preload target's class
      def klass
        reflection.active_record.send(:compute_type, name_without_count.singularize.classify)
      end

      def name_without_count
        reflection.name.to_s.sub(/_count$/, "")
      end
    end
  end
end
