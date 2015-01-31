require "active_record/precount/base_extension"
require "active_record/precount/has_many_extension"
require "active_record/precount/join_dependency_extension"
require "active_record/precount/preloader_extension"
require "active_record/precount/reflection_extension"
require "active_record/precount/relation_extension"

ActiveSupport.on_load(:active_record) do
  module ActiveRecord
    Base.send(:extend, Precount::BaseExtension)
    Relation.send(:prepend, Precount::RelationExtension)
    Reflection.send(:prepend, Precount::ReflectionExtension)
    Associations::Preloader.send(:prepend, Precount::PreloaderExtension)
    Associations::JoinDependency.send(:prepend, Precount::JoinDependencyExtension)
    Associations::Builder::HasMany.send(:prepend, Precount::Builder::HasManyExtension)
    Reflection::AssociationReflection.send(:prepend, Precount::AssociationReflectionExtension)
  end
end
