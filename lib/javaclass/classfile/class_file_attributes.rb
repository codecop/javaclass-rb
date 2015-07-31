module JavaClass
  module ClassFile

    # Class file attributes.
    # Author::   Peter Kofler
    class ClassFileAttributes

      def initialize(attributes)
        @attributes = attributes
      end

      # Name of the source file.
      def source_file
        @attributes.with('SourceFile').source_file
      end

    end

  end
end
