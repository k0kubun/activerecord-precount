require 'active_record/precount/count_loader_builder'

module ActiveRecord
  module Precount
    module Builder
      module HasManyExtension
        def valid_options(*)
          super + [:count_loader]
        end

        if ActiveRecord.version.segments.first >= 5
          def build(model, name, scope, options, &block)
            if scope.is_a?(Hash)
              options = scope
              scope   = nil
            end

            if options[:count_loader]
              CountLoaderBuilder.new(model).build(name, scope, options)
            end
            super
          end
        else
          def build(model)
            if options[:count_loader]
              CountLoaderBuilder.new(model).build(name, scope, options)
            end
            super
          end
        end
      end
    end
  end

  if ActiveRecord.version.segments.first >= 5
    Associations::Builder::HasMany.extend(Precount::Builder::HasManyExtension)
  else
    Associations::Builder::HasMany.prepend(Precount::Builder::HasManyExtension)
  end
end
