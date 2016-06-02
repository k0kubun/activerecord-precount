module ActiveRecord
  module Precount
    module BaseExtension
      delegate :precount, :eager_count, to: :all

      def reflection_for(name)
        reflections[name.to_s]
      end
    end
  end

  Base.extend(Precount::BaseExtension)
end
