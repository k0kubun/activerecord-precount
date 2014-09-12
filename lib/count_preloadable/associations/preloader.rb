require "active_record/associations/preloader/count_preloadable"

module CountPreloadable
  module Associations
    module Preloader
      private

      def preloader_for_with_count_preloadable(reflection, owners, rhs_klass)
        preloader = preloader_for_without_count_preloadable(reflection, owners, rhs_klass)
        return preloader if preloader

        case reflection.macro
        when :count_preloadable
          ActiveRecord::Associations::Preloader::CountPreloadable
        end
      end
    end
  end
end
