require 'javaclass/classpath/composite_classpath'

module JavaClass
  module Classpath
    
    # An Eclipse workspace aware classpath. 
    # Author::   Peter Kofler
    class EclipseClasspath < CompositeClasspath
      
      # Check if the _file_ is a valid location for an Eclipse classpath.
      def self.valid_location(file)
        FileTest.exist?(file) && FileTest.directory?(file) && FileTest.exist?(File.join(file, '.classpath'))
      end

      # Create a classpath for an Eclipse base project in _folder_ 
      def initialize(folder)
        raise IOError, "folder #{folder} not an Eclipse project" if !EclipseClasspath::valid_location(folder)
        super()
        @root = folder
        # TODO scan and add libs and outputs
#        classpath = IO.readlines(File.join(@root, '.classpath'))
#          
#        <classpathentry kind="lib" path="lib/jacob.jar"/>
#        <classpathentry kind="output" path="bin"/>
#        
#        add_file_name(File.join(@root, x))
      end

      def to_s
        @root
      end

    end

  end
end
