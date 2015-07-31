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

      # List of inner classes +Attributes::InnerClass+ with name and access flags.
      def inner_classes
        @attributes.with('InnerClasses').inner_classes
      end

      def inner_class?
        inner_classes.find { |inner| inner.class_name == @this_class }
      end

      def static_inner_class?
        inner_classes.find { |inner| inner.class_name == @this_class and inner.access_flags.static? }
      end

    end

  end
end
