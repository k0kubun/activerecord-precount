module ActiveRecord
  module Reflection
    module HasCount
      def create_with_has_count(macro, name, scope, options, ar)
        case macro
        when :has_count
          AssociationReflection.new(macro, name, scope, options, ar)
        else
          create_without_has_count(macro, name, scope, options, ar)
        end
      end
    end

    class AssociationReflection
      module HasCount
        def association_class_with_has_count
          case macro
          when :has_count
            ActiveRecord::Associations::HasCount
          else
            association_class_without_has_count
          end
        end
      end
    end
  end
end
