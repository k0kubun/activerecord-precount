module ActiveRecord
  module Precount
    module PreloaderExtension
      def preloader_for(reflection, owners, rhs_klass)
        preloader = super(reflection, owners, rhs_klass)
        return preloader if preloader

        case reflection.macro
        when :count_loader
          Associations::Preloader::CountLoader
        end
      end
    end
  end
end
