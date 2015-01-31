module ActiveRecord
  module Precount
    module BaseExtension
      delegate :precount, to: :all
    end
  end
end
