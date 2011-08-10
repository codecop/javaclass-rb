require 'javaclass/java_name'

module JavaClass
  module Classpath # :nodoc:
    
    # Abstraction of a folder on the CLASSPATH.
    # Author::   Peter Kofler
    class FolderClasspath
    
      # Return the list of classnames found in this _folder_ .
      def initialize(folder)
        @folder = folder
        raise IOError, "folder #{@folder} not found" if !FileTest.exist? @folder
        raise "#{@folder} is no folder" if !FileTest.directory? @folder
        @classes = list_classes.collect { |cl| cl.to_javaname }
      end

      # Return false.
      def jar?
        false
      end

      # Return an empty array.
      def additional_classpath
        []
      end

      # Return the list of class names found in this folder.
      def names
        @classes.dup
      end

      # Return if _classname_ is included in this folder.
      def includes?(classname)
        @classes.include?(classname.to_javaname.to_class_file)
      end

      # Load the binary data of the file name or class name _classname_ from this jar.
      def load_binary(classname)
        raise "class #{classname} not found in #{@folder}" unless includes?(classname)
        File.open(File.join(@folder, classname.to_javaname.to_class_file), 'rb') {|io| io.read }
      end

      # Return the number of classes in this folder.
      def count
        @classes.size
      end

      def to_s
        @folder
      end

      def ==(other)
        other.class == FolderClasspath && other.to_s == self.to_s
      end

      private

      # Return the list of classnames (in fact file names) found in this folder.
      def list_classes
        current = Dir.getwd
        begin
          Dir.chdir @folder

          list = Dir['**/*.class']

        ensure
          Dir.chdir current
        end
        list.sort
      end

    end

  end
end