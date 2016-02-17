require "active_record/precount/base_extension"
require "active_record/precount/collection_proxy_extension"
require "active_record/precount/has_many_extension"
require "active_record/precount/join_dependency_extension"
require "active_record/precount/preloader_extension"
require "active_record/precount/reflection_extension"
require "active_record/precount/relation_extension"

ActiveSupport.on_load(:active_record) do
  module ActiveRecord
    Base.send(:extend, Precount::BaseExtension)
    Relation.prepend(Precount::RelationExtension)
    Reflection.prepend(Precount::ReflectionExtension)
    Associations::Preloader.prepend(Precount::PreloaderExtension)
    Associations::JoinDependency.prepend(Precount::JoinDependencyExtension)
    Associations::CollectionProxy.prepend(Precount::CollectionProxyExtension)
    Associations::Builder::HasMany.prepend(Precount::Builder::HasManyExtension)
    Reflection::AssociationReflection.prepend(Precount::AssociationReflectionExtension)
  end
end
