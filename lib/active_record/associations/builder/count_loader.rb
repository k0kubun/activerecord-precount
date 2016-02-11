module ActiveRecord::Associations::Builder
  class CountLoader < SingularAssociation
    def self.valid_options
      [:class, :class_name, :foreign_key]
    end

    def macro
      :count_loader
    end

    def self.valid_dependent_options
      []
    end
  end
end
