module JavaClass
  module ClassFile

    # Class file attributes.
    # Author::   Peter Kofler
    class ClassFileAttributes

      def initialize(attributes, this_class)
        @attributes = attributes
        @this_class = this_class
      end

      # Name of the source file.
      def source_file
        @attributes.with('SourceFile').source_file
      end

      def inner_classes
        @attributes.with('InnerClasses').inner_classes
      end
      private :inner_classes

      def inner?
        inner_classes.include?(@this_class)
      end
      
    end

  end
end
