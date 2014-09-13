module ActiveRecord
  # This imitates EagerLoadPolymorphicError
  class EagerLoadHasCountError < ActiveRecordError
    def initialize(reflection)
      super("Cannot eagerly load the has_count association #{reflection.name.inspect}")
    end
  end

  module Associations
    class JoinDependency
      module HasCount
        def build_with_has_count(associations, base_klass)
          associations.map do |name, right|
            reflection = find_reflection base_klass, name
            if reflection.macro == :has_count
              raise EagerLoadHasCountError.new(reflection)
            end
          end

          build_without_has_count(associations, base_klass)
        end
      end
    end
  end
end
