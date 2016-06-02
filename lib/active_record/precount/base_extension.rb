module ActiveRecord
  module Precount
    module BaseExtension
      delegate :precount, :eager_count, to: :all
    end
  end

  Base.extend(Precount::BaseExtension)
end
