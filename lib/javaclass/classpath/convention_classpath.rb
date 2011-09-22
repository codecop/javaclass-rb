require 'javaclass/classpath/folder_classpath'
require 'javaclass/classpath/jar_classpath'

module JavaClass
  module Classpath

    # A Java project by naming convention, contains a classes and a lib folder.
    # Author::   Peter Kofler
    class ConventionClasspath < FolderClasspath

      CLASSES = 'classes'
      
      # Check if the _file_ is a valid location.
      def self.valid_location(file)
        FolderClasspath.valid_location(file) &&
        FolderClasspath.valid_location(File.join(file, CLASSES))
      end

      # Create a classpath for _folder_ / classes.
      def initialize(folder)
        super(File.join(folder, CLASSES))
        @root = folder
      end

      # Return list of additional classpath elements defined in the lib folder.
      def additional_classpath
        lib = File.join(@root, 'lib')
        if FolderClasspath.valid_location(lib)
          Dir.entries(lib).map { |e| File.join(lib, e) }.find_all { |e| JarClasspath.valid_location(e) }
        else
          []
        end
      end
      
    end

  end
end
