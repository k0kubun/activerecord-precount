module ActiveRecord::Associations::Builder
  class HasCount < SingularAssociation
    def macro
      :has_count
    end

    def valid_options
      [:foreign_key]
    end

    def self.valid_dependent_options
      []
    end
  end
end
