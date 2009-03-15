require 'javaclass/java_class_header'

# Author::          Peter Kofler
module JavaClass # :nodoc:
  
  # Convinience method to read and parse a class named _name_
  def self.parse(name)
    JavaClassHeader.new(File.open(name, 'rb') {|io| io.read } )
  end
  
end
