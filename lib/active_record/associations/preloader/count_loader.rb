module ActiveRecord
  module Associations
    class Preloader
      class CountLoader < SingularAssociation
        def association_key_name
          reflection.foreign_key
        end

        def owner_key_name
          reflection.active_record_primary_key
        end

        private

        def preload(preloader)
          associated_records_by_owner(preloader).each do |owner, associated_records|
            owner.association(reflection.name).target = associated_records.first.to_i
          end
        end

        def load_slices(slices)
          @preloaded_records = slices.flat_map { |slice|
            records_for(slice)
          }

          @preloaded_records.first.map { |key, count|
            [count, key]
          }
        end

        def query_scope(ids)
          scope.where(association_key.in(ids)).group(association_key_name).count(association_key_name)
        end
      end
    end
  end
end
