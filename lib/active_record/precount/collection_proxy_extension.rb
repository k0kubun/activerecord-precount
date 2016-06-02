require 'active_record/precount/reflection_checker'

module ActiveRecord
  module Precount
    module CollectionProxyExtension
      def count(*args)
        return super if args.present?

        counter_name = :"#{@association.reflection.name}_count"
        owner        = @association.owner

        if ReflectionChecker.has_reflection?(owner.class, counter_name) && owner.association(counter_name).loaded?
          owner.association(counter_name).target
        else
          super
        end
      end
    end
  end

  Associations::CollectionProxy.prepend(Precount::CollectionProxyExtension)
end
