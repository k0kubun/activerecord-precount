module ActiveRecord
  module Associations
    class Preloader
      class CountPreloadable < SingularAssociation
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
    end
  end
end
