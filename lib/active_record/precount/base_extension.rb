module ActiveRecord
  module Precount
    module BaseExtension
      delegate :precount, to: :all

      def has_reflection?(name)
        reflection_for(name).present?
      end

      def reflection_for(name)
        if ActiveRecord::VERSION::MAJOR >= 4 && ActiveRecord::VERSION::MINOR >= 2
          reflections[name.to_s]
        else
          reflections[name.to_sym]
        end
      end
    end
  end
end
