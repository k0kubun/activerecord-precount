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

        def key_conversion_required?
          # Are you sure this is always false? But this method is required to map result for polymorphic association.
          false
        end

        def preload(preloader)
          associated_records_by_owner(preloader).each do |owner, associated_records|
            owner.association(reflection.name).target = associated_records.first.to_i
          end
        end

        def query_scope(ids)
          key = model.reflections[reflection.name.to_s.sub(/_count\z/, '')].foreign_key
          scope.reorder(nil).where(key => ids).group(key).count(key)
        end

        def build_scope
          super.tap do |scope|
            has_many_reflection = model.reflections[reflection.name.to_s.sub(/_count\z/, '')]
            if has_many_reflection.options[:as]
              scope.where!(klass.table_name => { has_many_reflection.type => model.base_class.sti_name })
            end
          end
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
