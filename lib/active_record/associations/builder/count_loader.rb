module ActiveRecord::Associations::Builder
  class CountLoader < SingularAssociation
    self.valid_options = [:class_name, :foreign_key]

    def macro
      :count_loader
    end

    def self.valid_dependent_options
      []
    end
  end
end
