require 'javaclass/classpath/jar_classpath'
require 'javaclass/classpath/folder_classpath'
require 'javaclass/classpath/file_classpath'

module JavaClass

  # The module Classpath is for separating namespaces. It contains the abstraction of classpath to load binary class file data from.
  # It does not contain references to JavaClassHeader. It is low-level.
  # Author::          Peter Kofler
  module Classpath 

    # List of class path elements constructed from a full CLASSPATH variable.
    # Author::   Peter Kofler
    class CompositeClasspath < FileClasspath

      # Create an empty classpath composite root. The optional _file_ is for
      # identifying subclasses.
      def initialize(root='.')
        super(root)
        @elements = []
      end

      # Return all the classpath elements (the children) of this path and all child paths.
      def elements
        # [self] + */ 
        @elements.map { |cp| cp.elements }.flatten
      end

      # Add the _name_ class path which may be a file or a folder to this classpath.
      def add_file_name(name)
        if FolderClasspath.valid_location?(name)
          add_element(FolderClasspath.new(name))
        elsif JarClasspath.valid_location?(name)
          add_element(JarClasspath.new(name))
        else
          warn("tried to add an invalid classpath location #{name}")
        end
      end

      # Add the _elem_ classpath element to the list.
      def add_element(elem)
        @elements << elem unless elem.count == 0 || @elements.find { |cpe| cpe == elem } 
        elem.additional_classpath.each do |acpe|
          # referred classpath elements may be missing
          if JarClasspath.valid_location?(acpe)
            add_element(JarClasspath.new(acpe))
          end
        end
      end

      # Return the list of class names found in this classpath. An additional block is used as _filter_ on class names.
      def names(&filter)
        @elements.collect { |e| e.names(&filter) }.flatten.uniq
      end

      # Return if _classname_ is included in this classpath. If yes, return the count (usually 1).
      def includes?(classname)
        count = @elements.find_all { |e| e.includes?(classname) }.size 
        if count > 0 then count else nil end
      end

      # Load the binary data of the file name or class name _classname_ from this classpath.
      def load_binary(classname)
        found = @elements.find { |e| e.includes?(classname) }
        unless found
          raise ClassNotFoundError.new(classname, to_s)
        end
        found.load_binary(classname) 
      end

      # Return the number of classes in this classpath.
      def count
        @elements.inject(0) { |s,e| s + e.count }
      end

      def to_s
        str = super.to_s
        if str=='.'
          @elements.collect { |e| e.to_s }.join(',')
        else
          str
        end
      end

    end

  end
end
