require "active_support/lazy_load_hooks"

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
