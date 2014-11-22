ActiveSupport.on_load(:active_record) do
  module ActiveRecord
    Base.prepend(CountLoader::BaseExtension)
    Reflection.prepend(CountLoader::ReflectionExtension)
    Associations::JoinDependency.prepend(CountLoader::JoinDependencyExtension)
    Reflection::AssociationReflection.prepend(CountLoader::AssociationReflectionExtension)
  end
end
