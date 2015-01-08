ActiveSupport.on_load(:active_record) do
  module ActiveRecord
    Reflection.send(:prepend, CountLoader::ReflectionExtension)
    Associations::Preloader.send(:prepend, CountLoader::PreloaderExtension)
    Associations::JoinDependency.send(:prepend, CountLoader::JoinDependencyExtension)
    Associations::Builder::HasMany.send(:prepend, CountLoader::Builder::HasManyExtension)
    Reflection::AssociationReflection.send(:prepend, CountLoader::AssociationReflectionExtension)
  end
end
