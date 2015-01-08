module ActiveRecord
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

  module Reflection
    class CountLoaderReflection < AssociationReflection
      def initialize(name, scope, options, active_record)
        super(name, scope, options, active_record)
      end

      def macro; :count_loader; end
    end
  end
end
