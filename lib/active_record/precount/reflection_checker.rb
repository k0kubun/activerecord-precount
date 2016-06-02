module ActiveRecord
  module Precount
    module ReflectionChecker
      class << self
        def has_reflection?(klass, name)
          klass.reflections[name.to_s].present?
        end
      end
    end
  end
end
