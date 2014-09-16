module ActiveRecord
  module Associations
    class HasCount < SingularAssociation
      # Not preloaded behaviour of has_count association
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
end
