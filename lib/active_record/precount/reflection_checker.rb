module ActiveRecord
  module Precount
    module ReflectionChecker
      class << self
        def has_reflection?(klass, name)
          klass.reflections[name.to_s].present?
        end

        def count_loaded?(owner, name)
          has_reflection?(owner.class, name) && owner.association(name).loaded?
        end
      end
    end
  end
end
