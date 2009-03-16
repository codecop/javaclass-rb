require 'javaclass/java_class_header'

# Parse and disassemble Java class files, similar to the +javap+ command.
# Author::          Peter Kofler
# See::             http://java.sun.com/docs/books/jvms/second_edition/html/ClassFile.doc.html
# See::             http://en.wikipedia.org/wiki/Class_(file_format)
module JavaClass 
  
  # Read and disassemble the given class called _name_ (full file name).
  def self.parse(name)
    JavaClassHeader.new(File.open(name, 'rb') {|io| io.read } )
  end
  
end
