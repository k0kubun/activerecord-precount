module ActiveRecord
  module Precount
    module CollectionProxyExtension
      def count(*args)
        return super(*args) if args.present?

        counter_name = :"#{@association.reflection.name}_count"
        owner        = @association.owner

        if owner.class.has_reflection?(counter_name)
          owner.send(counter_name)
        else
          super(*args)
        end
      end
    end
  end
end
