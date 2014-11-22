module ActiveRecord
  module HasCount
    module Model
      def self.included(model)
        model.singleton_class.class_eval do
          include ClassMethods
        end
      end

      module ClassMethods
        private

        def has_count(name, scope = nil, options = {}, &extension)
          name_with_count = :"#{name}_count"

          reflection = ActiveRecord::Associations::Builder::HasCount.
            build(self, name_with_count, scope, options, &extension)
          ActiveRecord::Reflection.add_reflection(self, name_with_count, reflection)
        end
      end
    end
  end
end
