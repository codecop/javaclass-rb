require 'javaclass/classpath/class_not_found_error'

module JavaClass
  module Classpath

    # Abstract concept of a classpath pointing to a file.
    # Author::   Peter Kofler
    class FileClasspath

      # Create a classpath with this _root_ .
      def initialize(root)
        @root = root
      end

      # Return +false+ as this is no jar.
      def jar?
        false
      end

      # Return an empty array.
      def additional_classpath
        []
      end

      def to_s
        @root.to_s
      end

      # Equality with _other_ delegated to to_s.
      def ==(other)
        other.class == self.class && other.to_s == self.to_s
      end

      # Return the classpath elements of this (composite) classpath      
      def elements
        [self]
      end

      # Return the key for the access of this class file named _classname_ .      
      def to_key(classname)
        classname.to_javaname.to_class_file
      end
      
    end

  end
end