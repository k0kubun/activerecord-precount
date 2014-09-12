module CountPreloadable
  # This imitates EagerLoadPolymorphicError
  class EagerLoadCountPreloadableError < ActiveRecord::ActiveRecordError
    def initialize(reflection)
      super("Cannot eagerly load the count_preloadable association #{reflection.name.inspect}")
    end
  end

  module Associations
    module JoinDependency
      def build_with_count_preloadable(associations, base_klass)
        associations.map do |name, right|
          reflection = find_reflection base_klass, name
          if reflection.macro == :count_preloadable
            raise EagerLoadCountPreloadableError.new(reflection)
          end
        end

        build_without_count_preloadable(associations, base_klass)
      end
    end
  end
end
