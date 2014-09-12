module ActiveRecord
  module Associations
    class CountPreloadableAssociation < SingularAssociation
      # Not preloaded behaviour of count_preloadable association
      # When this method is called, it will be N+1 query
      def reader(force_reload = false)
        count_target = name_without_count.to_sym
        owner.association(count_target).count
      end

      def klass
        reflection.active_record.send(:compute_type, name_without_count.singularize.classify)
      end

      def name_without_count
        reflection.name.to_s.sub(/_count$/, "")
      end
    end
  end
end
