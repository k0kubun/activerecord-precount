require "active_record"
require "active_support/lazy_load_hooks"

require "active_record/associations/count_loader"
require "active_record/associations/builder/count_loader"
require "active_record/associations/preloader/count_loader"
require "active_record/associations/join_dependency/count_loader"
require "active_record/reflection/count_loader"

ActiveSupport.on_load(:active_record) do
  require "active_record/count_loader/model"
  ActiveRecord::Base.send(:include, ActiveRecord::CountLoader::Model)
end

module ActiveRecord
  module Reflection
    class << self
      include CountLoader
      alias_method_chain :create, :count_loader
    end

    class AssociationReflection
      include CountLoader
      alias_method_chain :klass, :count_loader
      alias_method_chain :association_class, :count_loader
    end
  end
end

module ActiveRecord
  module Associations
    class JoinDependency
      include CountLoader
      alias_method_chain :build, :count_loader
    end
  end
end
