module ActiveRecord
  module CountLoader
    module BaseExtension
      def self.prepended(base)
        base.singleton_class.class_eval do
          prepend ClassMethods
        end
      end

      module ClassMethods
        private

        def count_loader(name, scope = nil, options = {}, &extension)
          name_with_count = :"#{name}_count"

          reflection = ActiveRecord::Associations::Builder::CountLoader.
            build(self, name_with_count, scope, options, &extension)
          ActiveRecord::Reflection.add_reflection(self, name_with_count, reflection)
        end
      end
    end
  end
end
