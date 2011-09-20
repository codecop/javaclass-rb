require 'javaclass/classfile/java_class_header'
require 'javaclass/classpath/factory'
require 'javaclass/classscanner/scanners'

# Main entry point for class file parsing. This module ties together all ClassFile and Classpath modules.
# Author::          Peter Kofler
module JavaClass
  extend Classpath::Factory
  extend ClassScanner::Scanners

  # Read and disassemble the given class from _filename_ (full file name).
  def self.load_fs(filename)
    disassemble(File.open(filename, 'rb') { |io| io.read } )
  end

  def self.parse(filename)
    warn 'Deprecated method JavaClass::parse will be removed in next release. Use method load_fs instead.'
    load_fs(filename)
  end

  # Read and disassemble the given class _classname_ from _classpath_ .
  def self.load_cp(classname, classpath)
    disassemble(classpath.load_binary(classname))
  end

  # Read and disassemble the given class inside _data_ (byte data).
  # This creates a +JavaClassHeader+ .
  def self.disassemble(data)
    ClassFile::JavaClassHeader.new(data)
  end
    
end
