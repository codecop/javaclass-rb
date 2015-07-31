module JavaClass
  module ClassFile

    # Class file attributes.
    # Author::   Peter Kofler
    class ClassFileAttributes

      def initialize(attributes)
        @attributes = attributes
      end
      
      # Return the number of attributes.
      def count
        @attributes.count
      end

    end

  end
end
