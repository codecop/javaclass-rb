require 'zip/zipfilesystem'
require 'javaclass/classpath/jar_classpath'
require 'javaclass/classpath/folder_classpath'

module JavaClass
  module Classpath 
    
    # List of class path elements. 
    # Author::   Peter Kofler
    class CompositeClasspath
      
      # Return the list of classnames found in this _jarfile_ . 
      def initialize
        @elements = []
      end
      
      # Return the classpath elements of this path.
      def elements
        @elements.dup
      end
      
      # Add the _name_ class path file name to the list.
      def add_file_name(name)
        if FileTest.directory? name
          add_element(FolderClasspath.new(name))
        else
          add_element(JarClasspath.new(name))
        end
      end
      
      # Add the _elem_ classpath element to the list. 
      def add_element(elem)
        @elements << elem
        elem.additional_classpath.each {|acpe| add_element(JarClasspath.new(acpe)) }
      end
      
      # Return false.
      def jar?
        false
      end
      
      # Return an empty array.
      def additional_classpath
        []
      end
      
      # Return the list of class names found in this classpath.
      def names
        @elements.collect { |e| e.names }.flatten.uniq
      end
      
      # Return if _classname_ is included in this classpath.
      def includes?(classname)
        @elements.find { |e| e.includes?(classname) } != nil
      end
      
      # Load the binary data of the file name or class name _classname_ from this classpath.
      def load_binary(classname)
        found = @elements.find { |e| e.includes?(classname) }
        if (found)
          return found.load_binary(classname)
        end
        raise "class #{classname} not found in classpath #{to_s}" 
      end
      
      # Return the number of classes in this jar.
      def count
        @elements.inject(0) { |s,e| s + e.count }
      end
      
      def to_s
        @elements.collect { |e| e.to_s }
      end
      
    end
    
  end
end
