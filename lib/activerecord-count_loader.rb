require "active_record"
require "active_support/lazy_load_hooks"

require "active_record/associations/count_loader"
require "active_record/associations/builder/count_loader"
require "active_record/associations/preloader/count_loader"

require "active_record/count_loader/base_extension"
require "active_record/count_loader/join_dependency_extension"
require "active_record/count_loader/reflection_extension"
require "active_record/count_loader/extend"
