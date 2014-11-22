module ActiveRecord::Associations::Builder
  class CountLoader < SingularAssociation
    def macro
      :count_loader
    end

    def valid_options
      [:class_name, :foreign_key]
    end

    def self.valid_dependent_options
      []
    end
  end
end
