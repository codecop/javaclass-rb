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
        a = @attributes.with('SourceFile')
        if a then a.source_file else '<not set>' end
      end

      # List of inner classes +Attributes::InnerClass+ with name and access flags.
      def inner_classes
        a = @attributes.with('InnerClasses')
        if a then a.inner_classes else [] end
      end

      def inner_class?
        if inner_classes.find { |inner| inner.class_name == @this_class }
          true
        else
          false
        end
      end

      # Defines an accessible inner class, which is a static inner class which is not synthetic.
      def accessible_inner_class?
        if inner_classes.find { |inner| inner.class_name == @this_class &&  inner.access_flags.static? && !inner.access_flags.synthetic? }
          true
        else
          false
        end
      end

    end

  end
end
