require 'javaclass/classpath/file_classpath'
require 'javaclass/java_language'
require 'javaclass/java_name'

module JavaClass
  module Classpath

    # Abstraction of a folder on the CLASSPATH. This is a leaf in the classpath tree.
    # Author::   Peter Kofler
    class FolderClasspath < FileClasspath

      # Check if the _file_ is a valid location for a folder classpath.
      def self.valid_location?(file)
        FileTest.exist?(file) && FileTest.directory?(file) 
      end
      
      # Create a classpath with this _folder_ .
      def initialize(folder)
        super(folder)
        unless FolderClasspath::valid_location?(folder)
          raise IOError, "folder #{folder} not found/no folder"
        end
        @folder = folder
        init_classes
      end
      
      # Return the list of class names found in this folder. An additional block is used as _filter_ on class names.
      def names(&filter)
        if block_given?
          @class_names.find_all { |n| filter.call(n) }
        else
          @class_names.dup
        end
      end

      # Return if _classname_ is included in this folder.
      def includes?(classname)
        @class_lookup[to_key(classname).file_name] 
      end

      # Load the binary data of the file name or class name _classname_ from this folder.
      def load_binary(classname)
        key = to_key(classname)
        unless includes?(key)
          raise ClassNotFoundError.new(key, @folder)
        end
        File.open(File.join(@folder, key), 'rb') { |io| io.read.freeze }
      end

      # Return the number of classes in this folder.
      def count
        @class_names.size
      end

      private

      # Return the list of classnames (in fact file names) found in this folder.
      def list_classes
        current = Dir.getwd
        begin
          Dir.chdir @folder

          list = Dir["**/*#{JavaLanguage::CLASS}"]

        ensure
          Dir.chdir current
        end
        list
      end

      # Set up the class names.
      def init_classes
        @class_names = list_classes.sort.reject { |n| n =~ /package-info\.class$/ }.collect { |cl| JavaClassFileName.new(cl) } 
        pairs = @class_names.map { |name| [name.file_name, 1] }.flatten
        @class_lookup = Hash[ *pairs ] # file_name (String) => anything
      end
      
    end

  end
end