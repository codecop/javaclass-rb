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
        raise IOError, "folder #{folder} not found/no folder" if !FolderClasspath::valid_location?(folder)
        @folder = folder
        @classes = list_classes.collect { |cl| JavaClassFileName.new(cl) } 
        pairs = @classes.map { |name| [name, 1] }.flatten
        @class_lookup = Hash[ *pairs ]
      end

      # Return the list of class names found in this folder. An additional block is used as _filter_ on class names.
      def names(&filter)
        if block_given?
          @classes.find_all { |n| filter.call(n) }
        else
          @classes.dup
        end
      end

      # Return if _classname_ is included in this folder.
      def includes?(classname)
        @class_lookup[classname.to_javaname.to_class_file] 
      end

      # Load the binary data of the file name or class name _classname_ from this folder.
      def load_binary(classname)
        key = classname.to_javaname.to_class_file
        raise "class #{key} not found in #{@folder}" unless includes?(key)
        File.open(File.join(@folder, key), 'rb') {|io| io.read }
      end

      # Return the number of classes in this folder.
      def count
        @classes.size
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
        list.sort
      end

    end

  end
end