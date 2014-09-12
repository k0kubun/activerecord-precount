module ActiveRecord::Associations
  module ClassMethods
    def has_many_with_count_preloadable(*args)
      has_many_without_count_preloadable(*args)
    end
    alias_method_chain :has_many, :count_preloadable
  end
end
