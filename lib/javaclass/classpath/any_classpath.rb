require 'javaclass/classpath/composite_classpath'

module JavaClass
  module Classpath

    # Classpath containing everything under a folder. This is for an unstructured 
    # collection of JARs and class files.
    # Author::   Peter Kofler
    class AnyClasspath < CompositeClasspath

      # Create a classpath with all classes found under this _folder_ wherever they are.
      def initialize(folder)
        super(File.join(folder, '*'))
        find_jars(folder)
        # TODO find_classes(folder)
        # add_file_name(sub_folders) - so the names are correct package names
      end
      
      # Search the given _path_ recursively for zips or jars. Add all found jars to this classpath.
      def find_jars(path)
        if FileTest.file?(path) && path =~ /\.jar$|\.zip$/
          add_file_name File.expand_path(path)
          return
        end
        
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
      
    end

  end
end
