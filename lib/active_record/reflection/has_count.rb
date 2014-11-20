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
        def klass_with_has_count
          case macro
          when :has_count
            @klass ||= active_record.send(:compute_type, options[:class_name] || name_without_count.singularize.classify)
          else
            klass_without_has_count
          end
        end

        def name_without_count
          name.to_s.sub(/_count$/, "")
        end

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
