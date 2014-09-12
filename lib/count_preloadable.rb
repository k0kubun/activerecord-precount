module ActiveRecord::Associations
  module ClassMethods
    def has_many_with_count_preloadable(name, scope = nil, options = {}, &extension)
      # NOTE: I don't want to do this in this layer...
      if scope.is_a?(Hash)
        options = scope
        scope   = nil
      end

      new_options = original_options.dup
      count_preloadable = new_options.delete(:count_preloadable)
      if count_preloadable
        # reflection = Builder::CountPreloadable.build(self, name, scope, options, &extension)
        # Reflection.add_reflection self, name, reflection
      end

      has_many_without_count_preloadable(name, scope, new_options, &extension)
    end
    alias_method_chain :has_many, :count_preloadable
  end
end
