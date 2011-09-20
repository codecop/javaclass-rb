require 'javaclass/classpath/jar_classpath'
require 'javaclass/classpath/folder_classpath'

module JavaClass

  # The module Classpath is for separating namespaces. It contains the abstraction of classpath to load binary class file data from.
  # It does not contain references to JavaClassHeader. It is low-level.
  # Author::          Peter Kofler
  module Classpath # :nodoc:

    # List of class path elements constructed from a full CLASSPATH variable.
    # Author::   Peter Kofler
    class CompositeClasspath

      # Create an empty classpath composite root.
      def initialize
        @elements = []
      end

      # Return all the classpath elements (the children) of this path and all child paths.
      def elements
        # [self] + */ 
        @elements.map { |cp| cp.elements }.flatten
      end

      # Search the given _path_ recursively for zips or jars. Add all found jars to this classpath.
      def find_jars(path)
        current = Dir.getwd
        begin
          Dir.chdir File.expand_path(path)

          Dir['*'].collect do |name|
            if FileTest.directory?(name)
              find_jars(name)
            elsif name =~ /\.jar$|\.zip$/
              add_file_name File.expand_path(name)
            end
          end

        ensure
          Dir.chdir current
        end
      end

      # Add the _name_ class path which may be a file or a folder to this classpath.
      def add_file_name(name)
        if FolderClasspath.valid_location(name)
          add_element(FolderClasspath.new(name))
        elsif JarClasspath.valid_location(name)
          add_element(JarClasspath.new(name))
        else
          # warn("tried to add invalid classpath location #{name}")
        end
      end

      # Add the _elem_ classpath element to the list.
      def add_element(elem)
        @elements << elem unless elem.count == 0 || @elements.find { |cpe| cpe == elem } 
        elem.additional_classpath.each do |acpe|
          # referred classpath elements may be missing
          if JarClasspath.valid_location(acpe)
            add_element(JarClasspath.new(acpe))
          end
        end
      end

      # Return false.
      def jar?
        false
      end

      # Return an empty array.
      def additional_classpath
        []
      end

      # Return the list of class names found in this classpath. An additional block is used as _filter_ on class names.
      def names(&filter)
        @elements.collect { |e| e.names(&filter) }.flatten.uniq
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

      # Return the number of classes in this classpath.
      def count
        @elements.inject(0) { |s,e| s + e.count }
      end

      def ==(other)
        other.class == self.class && other.to_s == self.to_s
      end
      
      def to_s
        @elements.collect { |e| e.to_s }.join(',')
      end

    end

  end
end
