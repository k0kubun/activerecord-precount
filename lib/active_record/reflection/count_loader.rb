module ActiveRecord
  module Reflection
    module CountLoader
      def create_with_count_loader(macro, name, scope, options, ar)
        case macro
        when :count_loader
          AssociationReflection.new(macro, name, scope, options, ar)
        else
          create_without_count_loader(macro, name, scope, options, ar)
        end
      end
    end

    class AssociationReflection
      module CountLoader
        def klass_with_count_loader
          case macro
          when :count_loader
            @klass ||= active_record.send(:compute_type, options[:class_name] || name_without_count.singularize.classify)
          else
            klass_without_count_loader
          end
        end

        def name_without_count
          name.to_s.sub(/_count$/, "")
        end

        def association_class_with_count_loader
          case macro
          when :count_loader
            ActiveRecord::Associations::CountLoader
          else
            association_class_without_count_loader
          end
        end
      end
    end
  end
end
