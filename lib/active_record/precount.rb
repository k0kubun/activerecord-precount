require "active_support/lazy_load_hooks"

# How it works:
#
# 1. has_many :foo, count_loader: true
#   * has_many_extension:               Create and add a reflection for :count_loader in has_many method
#     * reflection_extension:             CountLoaderReflection is required in reflection creation
#   * association_reflection_extension: Return CountLoader in association_class
#     * association_reflection_extension: CountLoader#load_target loads counts when not eager-loaded
#     * preloader_extension:              Return CountLoader preloader and preload in it
#     * join_dependency_extension:        Use COUNT query in #aliases for eager_load and map it in #construct
#       * collection_proxy_extension:       Fallback to eager-loaded values when foo.count is called
#         * base_extension:                   Check model has the association
#
# 2. precount(:foo)
#   * relation_extension:               Add #precount query method, which defines count_loader association and adds preload_values
#     * base_extension:                   Delegate it for class method
#   * association_reflection_extension: Return CountLoader in association_class
#     * preloader_extension:              Return CountLoader preloader and preload in it
#       * collection_proxy_extension:       Fallback to eager-loaded values when foo.count is called
#         * base_extension:                   Check model has the association
#
# 3. eager_count(:foo)
#   * relation_extension:               Add #eager_count query method, which defines count_loader association and adds eager_load_values
#     * base_extension:                   Delegate it for class method
#   * association_reflection_extension: Return CountLoader in association_class
#     * join_dependency_extension:        Use COUNT query in #aliases for eager_load and map it in #construct
#       * collection_proxy_extension:       Fallback to eager-loaded values when foo.count is called
#         * base_extension:                   Check model has the association
#
ActiveSupport.on_load(:active_record) do
  require "active_record/precount/association_reflection_extension"
  require "active_record/precount/base_extension"
  require "active_record/precount/collection_proxy_extension"
  require "active_record/precount/has_many_extension"
  require "active_record/precount/relation_extension"
  require "active_record/precount/reflection_extension"
  require "active_record/precount/preloader_extension"
  require "active_record/precount/join_dependency_extension"
end
