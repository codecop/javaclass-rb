require 'javaclass/classfile/java_class_header'
require 'javaclass/classfile/java_class_header_as_java_name'

module JavaClass
  module Dsl

    # Load the classfiles and create the JavaClassHeader. This module ties together all ClassFile and Classpath modules.
    # Author::          Peter Kofler
    module Loader

      # Read and disassemble the given class from _filename_ (full file name).
      def load_fs(filename)
        begin
          disassemble(File.open(filename, 'rb') { |io| io.read } )
        rescue ClassFile::ClassFormatError => ex
          ex.add_classname(filename)
          raise ex
        end
      end

      # Read and disassemble the given class _classname_ from _classpath_ .
      def load_cp(classname, classpath)
        begin
          disassemble(classpath.load_binary(classname), classpath)
        rescue ClassFile::ClassFormatError => ex
          ex.add_classname(classname, classpath.to_s)
          raise ex
        end
      end

      # Read and disassemble the given class inside _data_ (byte data). Might throw a 
      # ClassFile::ClassFormatError if the classfile is not valid. Optional _from_classpath_
      # describes the classpath it was loaded from.
      # This creates a +ClassFile::JavaClassHeader+ .
      def disassemble(data, from_classpath=nil)
        ClassFile::JavaClassHeader.new(data, from_classpath)
      end

    end

  end
end
