module ActiveRecord
  # This imitates EagerLoadPolymorphicError
  class EagerLoadCountLoaderError < ActiveRecordError
    def initialize(reflection)
      super("Cannot eagerly load the count_loader association #{reflection.name.inspect}")
    end
  end

  module CountLoader
    module JoinDependencyExtension
      def build(associations, base_klass)
        associations.map do |name, right|
          reflection = find_reflection base_klass, name
          if reflection.macro == :count_loader
            raise EagerLoadCountLoaderError.new(reflection)
          end
        end

        super(associations, base_klass)
      end
    end
  end
end
