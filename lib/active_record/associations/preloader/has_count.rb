module ActiveRecord
  module Associations
    class Preloader
      class HasCount < SingularAssociation
        def association_key_name
          reflection.foreign_key
        end

        def owner_key_name
          reflection.active_record_primary_key
        end

        private

        def preload(preloader)
          associated_records_by_owner(preloader).each do |owner, associated_records|
            count = associated_records.count

            association = owner.association(reflection.name)
            association.target = count
          end
        end
      end

      private

      def preloader_for_with_has_count(reflection, owners, rhs_klass)
        preloader = preloader_for_without_has_count(reflection, owners, rhs_klass)
        return preloader if preloader

        case reflection.macro
        when :has_count
          HasCount
        end
      end
      alias_method_chain :preloader_for, :has_count
    end
  end
end
