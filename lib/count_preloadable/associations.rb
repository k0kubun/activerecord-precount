require "active_record/associations/builder/count_preloadable"

module CountPreloadable
  module Associations
    module ClassMethods
      def count_preloadable(name, scope = nil, options = {}, &extension)
        name_with_count = :"#{name}_count"

        reflection = ActiveRecord::Associations::Builder::CountPreloadable.
          build(self, name_with_count, scope, options, &extension)
        ActiveRecord::Reflection.add_reflection(self, name_with_count, reflection)
      end
    end
  end
end
