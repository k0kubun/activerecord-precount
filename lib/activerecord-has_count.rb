require "active_record"
require "active_support/lazy_load_hooks"

require "active_record/associations/has_count"
require "active_record/associations/builder/has_count"
require "active_record/associations/preloader/has_count"
require "active_record/associations/join_dependency/has_count"
require "active_record/reflection/has_count"

ActiveSupport.on_load(:active_record) do
  require "activerecord-has_count/model"
  ActiveRecord::Base.send(:include, ActiveRecord::HasCount::Model)
end

module ActiveRecord
  module Reflection
    class << self
      include HasCount
      alias_method_chain :create, :has_count
    end

    class AssociationReflection
      include HasCount
      alias_method_chain :klass, :has_count
      alias_method_chain :association_class, :has_count
    end
  end
end

module ActiveRecord
  module Associations
    class JoinDependency
      include HasCount
      alias_method_chain :build, :has_count
    end
  end
end
