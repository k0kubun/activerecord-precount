module ActiveRecord::Associations::Builder
  class CountPreloadable < SingularAssociation
    def macro
      :count_preloadable
    end

    def valid_options
      []
    end

    def self.valid_dependent_options
      []
    end
  end
end
