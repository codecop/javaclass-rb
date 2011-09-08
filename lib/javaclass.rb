require 'javaclass/classfile/java_class_header'
require 'javaclass/classpath/java_home_classpath'
require 'javaclass/classpath/composite_classpath'
require 'javaclass/classscanner/imported_types'

# Main entry point for class file parsing. This module ties together the ClassFile and Classpath modules.
# Author::          Peter Kofler
module JavaClass

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
  
  # Scan parsed _header_ for (selected) _features_ .
  def self.analyse(header, features=:all)
    # TODO implement feature selection
    # have an argument to determine delegators, :none, :some, :all
    ClassScanner::ImportedTypes.new(header)
  end

  # Parse the given path variable _path_ and return a chain of class path elements.
  def self.classpath(path)
    full_classpath(nil, path)
  end

  # Parse and scan the system classpath. Needs +JAVA_HOME+ set. Uses environment +CLASSPATH+ if set.
  def self.environment_classpath
    full_classpath(ENV['JAVA_HOME'], ENV['CLASSPATH'])
  end

  # Parse the given path variable _path_ and return a chain of class path elements together with _javahome_ if any.
  # This creates a CompositeClasspath.
  def self.full_classpath(javahome, path='')
    cp = Classpath::CompositeClasspath.new
    cp.add_element(Classpath::JavaHomeClasspath.new(javahome)) if javahome
    path.split(File::PATH_SEPARATOR).each { |cpe| cp.add_file_name(cpe) } if path
    cp
  end
  
end
