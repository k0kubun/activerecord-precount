module ActiveRecord::Associations::Builder
  class CountLoader < SingularAssociation
    def valid_options
      super + [:primary_key, :dependent, :as, :through, :source, :source_type, :inverse_of, :counter_cache, :join_table, :foreign_type]
    end

    def macro
      :count_loader
    end

    def self.valid_dependent_options
      []
    end
  end
end
