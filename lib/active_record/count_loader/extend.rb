ActiveSupport.on_load(:active_record) do
  module ActiveRecord
    Reflection.prepend(CountLoader::ReflectionExtension)
    Associations::Preloader.prepend(CountLoader::PreloaderExtension)
    Associations::JoinDependency.prepend(CountLoader::JoinDependencyExtension)
    Associations::Builder::HasMany.prepend(CountLoader::Builder::HasManyExtension)
    Reflection::AssociationReflection.prepend(CountLoader::AssociationReflectionExtension)
  end
end
