require 'javaclass/classpath/java_home_classpath'
require 'javaclass/classpath/composite_classpath'

module JavaClass
  module Classpath

    # Factory methods to create different kind of classpaths.
    # Author::          Peter Kofler
    module Factory
      
      # Parse the given path variable _path_ and return a chain of class path elements. 
      # The path variable is separated by : or ; depending on the platform. 
      # Adds the classpath to the optional _cp_ element else creates a CompositeClasspath.
      def classpath(path, cp=CompositeClasspath.new)
        path.split(File::PATH_SEPARATOR).each { |cpe| cp.add_file_name(cpe) } 
        cp
      end
    
      # Parse and set the system classpath. Needs +JAVA_HOME+ to be set. Uses additional environment 
      # +CLASSPATH+ if set. Adds the classpath to the optional _cp_ element else creates a CompositeClasspath.
      def environment_classpath(cp=CompositeClasspath.new)
        full_classpath(ENV['JAVA_HOME'], ENV['CLASSPATH'], cp)
      end
    
      # Parse the given path variable _path_ and return a chain of class path elements together with _javahome_ if any.
      def full_classpath(javahome, path=nil, cp=CompositeClasspath.new)
        cp.add_element(JavaHomeClasspath.new(javahome)) if javahome
        cp = classpath(path, cp) if path
        cp
      end
      
      # Create a classpath from a workspace _basepath_ which contains Eclipse or Maven projects. 
      def workspace(basepath, cp=CompositeClasspath.new)
        Dir.entries(basepath).each do |entry|
          file = File.join(basepath, entry)
          
          [EclipseClasspath, MavenClasspath, JarClasspath].each do |classpath_type|
            # TODO CONTINUE 10 - add a naming conventions classpath with ./classes ./lib ./bin
            if classpath_type.valid_location(file)
              cp.add_element(classpath_type.new(file))
            end
          end
          
        end
        cp
      end
      
    end
    
  end
end
