module ActiveRecord
  module CountLoader
    module BaseExtension
      delegate :precount, to: :all
    end
  end
end
