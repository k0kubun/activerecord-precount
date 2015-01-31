require "active_record/count_loader/base_extension"
require "active_record/count_loader/has_many_extension"
require "active_record/count_loader/join_dependency_extension"
require "active_record/count_loader/preloader_extension"
require "active_record/count_loader/reflection_extension"
require "active_record/count_loader/relation_extension"

ActiveSupport.on_load(:active_record) do
  module ActiveRecord
    Base.send(:extend, CountLoader::BaseExtension)
    Relation.send(:prepend, CountLoader::RelationExtension)
    Reflection.send(:prepend, CountLoader::ReflectionExtension)
    Associations::Preloader.send(:prepend, CountLoader::PreloaderExtension)
    Associations::JoinDependency.send(:prepend, CountLoader::JoinDependencyExtension)
    Associations::Builder::HasMany.send(:prepend, CountLoader::Builder::HasManyExtension)
    Reflection::AssociationReflection.send(:prepend, CountLoader::AssociationReflectionExtension)
  end
end
