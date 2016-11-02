module ActiveRecord
  module Precount
    module AutosaveAssociationExtension
      private

      def save_belongs_to_association(reflection)
        return if reflection.is_a? ActiveRecord::Reflection::CountLoaderReflection
        super(reflection)
      end
    end
  end

  Base.prepend(Precount::AutosaveAssociationExtension)
end
