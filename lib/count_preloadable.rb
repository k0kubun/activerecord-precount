require "count_preloadable/associations"
require "count_preloadable/associations/preloader"
require "count_preloadable/associations/join_dependency"
require "count_preloadable/reflection"

module ActiveRecord
  module Associations
    module ClassMethods
      include ::CountPreloadable::Associations::ClassMethods
    end
  end
end

module ActiveRecord
  module Reflection
    extend ::CountPreloadable::Reflection

    class << self
      alias_method_chain :create, :count_preloadable
    end

    class AssociationReflection
      include ::CountPreloadable::Reflection::AssociationReflection
      alias_method_chain :association_class, :count_preloadable
    end
  end
end

module ActiveRecord
  module Associations
    class Preloader
      include ::CountPreloadable::Associations::Preloader
      alias_method_chain :preloader_for, :count_preloadable
    end
  end
end

module ActiveRecord
  module Associations
    class JoinDependency
      include ::CountPreloadable::Associations::JoinDependency
      alias_method_chain :build, :count_preloadable
    end
  end
end
