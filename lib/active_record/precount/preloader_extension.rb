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

        def query_scope(ids)
          scope.where(association_key.in(ids)).group(association_key_name).count(association_key_name)
        end

        if ActiveRecord.version.segments.first >= 5
          def load_records
            return {} if owner_keys.empty?

            slices  = owner_keys.each_slice(klass.connection.in_clause_length || owner_keys.size)
            @preloaded_records = slices.flat_map { |slice|
              records_for(slice)
            }

            Hash[@preloaded_records.first.map { |key, count| [key, [count]] }]
          end
        else
          def load_slices(slices)
            @preloaded_records = slices.flat_map { |slice|
              records_for(slice)
            }

            @preloaded_records.first.map { |key, count|
              [count, key]
            }
          end
        end
      end
    end
  end

  module Precount
    module PreloaderExtension
      def preloader_for(reflection, owners, rhs_klass)
        preloader = super
        return preloader if preloader

        case reflection.macro
        when :count_loader
          Associations::Preloader::CountLoader
        end
      end
    end
  end

  Associations::Preloader.prepend(Precount::PreloaderExtension)
end
