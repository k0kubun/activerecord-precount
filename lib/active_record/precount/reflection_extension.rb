module ActiveRecord
  module Reflection
    class CountLoaderReflection < AssociationReflection
      def initialize(name, scope, options, active_record)
        super(name, scope, options, active_record)
      end

      def macro; :count_loader; end
    end
  end

  module Precount
    module ReflectionExtension
      def self.prepended(base)
        class << base
          prepend ClassMethods
        end
      end

      module ClassMethods
        def create(macro, name, scope, options, ar)
          case macro
          when :count_loader
            Reflection::CountLoaderReflection.new(name, scope, options, ar)
          else
            super(macro, name, scope, options, ar)
          end
        end
      end
    end
  end

  Reflection.prepend(Precount::ReflectionExtension)
end
