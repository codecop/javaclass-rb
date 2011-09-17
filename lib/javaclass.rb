require 'javaclass/classfile/java_class_header'
require 'javaclass/classpath/factory'
require 'javaclass/classscanner/imported_types'

# Main entry point for class file parsing. This module ties together the ClassFile and Classpath modules.
# Author::          Peter Kofler
module JavaClass
  extend JavaClass::Classpath::Factory

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
  # This creates a JavaClassHeader.
  def self.disassemble(data)
    ClassFile::JavaClassHeader.new(data)
  end
  
  # Scan parsed _header_ . 
  def self.analyse(header)
    # TODO move logic similar to Factory into a Scanners module.
    ClassScanner::ImportedTypes.new(
      header
    )
  end
    
end
