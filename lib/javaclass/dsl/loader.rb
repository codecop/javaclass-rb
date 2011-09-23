require 'javaclass/classfile/java_class_header'

module JavaClass
  module Dsl

    # Load the classfiles and create the JavaClassHeader. This module ties together all ClassFile and Classpath modules.
    # Author::          Peter Kofler
    module Loader

      # Read and disassemble the given class from _filename_ (full file name).
      def load_fs(filename)
        disassemble(File.open(filename, 'rb') { |io| io.read } )
      end

      # Read and disassemble the given class _classname_ from _classpath_ .
      def load_cp(classname, classpath)
        disassemble(classpath.load_binary(classname))
      end

      # Read and disassemble the given class inside _data_ (byte data).
      # This creates a +JavaClassHeader+ .
      def disassemble(data)
        ClassFile::JavaClassHeader.new(data)
      end

    end

  end
end
