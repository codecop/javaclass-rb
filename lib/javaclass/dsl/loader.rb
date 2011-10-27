require 'javaclass/classfile/java_class_header'
require 'javaclass/classfile/java_class_header_as_java_name'
require 'javaclass/classfile/java_class_header_shortcuts'

module JavaClass
  module Dsl

    # Load the classfiles and create the JavaClassHeader. This module ties together all ClassFile and Classpath modules.
    # Author::          Peter Kofler
    module Loader

      # Read and disassemble the given class from _filename_ (full file name).
      def load_fs(filename)
        begin
          disassemble(File.open(filename, 'rb') { |io| io.read.freeze } )
        rescue ClassFile::ClassFormatError => ex
          ex.add_classname(filename)
          raise ex
        end
      end

      # Read and disassemble the given class _classname_ from _classpath_ .
      def load_cp(classname, classpath)
        begin
          disassemble(classpath.load_binary(classname))
        rescue ClassFile::ClassFormatError => ex
          ex.add_classname(classname, classpath.to_s)
          raise ex
        end
      end

      # Read and disassemble the given class inside _data_ (byte data). Might throw a 
      # ClassFile::ClassFormatError if the classfile is not valid.
      # This creates a +ClassFile::JavaClassHeader+ .
      def disassemble(data)
        ClassFile::JavaClassHeader.new(data)
      end

    end

  end
end
