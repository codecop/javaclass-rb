require 'javaclass/classpath/java_home_classpath'
require 'javaclass/classpath/composite_classpath'
require 'javaclass/classpath/maven_classpath'
require 'javaclass/classpath/eclipse_classpath'
require 'javaclass/classpath/convention_classpath'

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
      
      Classpath_types = [EclipseClasspath, MavenClasspath, ConventionClasspath]
      
      # Create a classpath from a workspace _basepath_ which contains Eclipse or Maven projects.
      def workspace(basepath, cp=CompositeClasspath.new)

        # check for a valid project in this basepath
        Classpath_types.each do |classpath_type|
          if classpath_type.valid_location?(basepath)
            cp.add_element(classpath_type.new(basepath))
            return cp
          end
        end

        root_folder(basepath, cp)
      end
      
      # Create a classpath from a project root directory _basepath_ by looking in the children folder for regular workspaces.
      def root_folder(basepath, cp=CompositeClasspath.new)
        if FileTest.directory? basepath
        
          Dir.entries(basepath).each do |entry|
            next if entry == '.' || entry == '..'
            file = File.join(basepath, entry)
  
            Classpath_types.each do |classpath_type|
              if classpath_type.valid_location?(file)
                cp.add_element(classpath_type.new(file))
                break
              end
            end
          end
        
        end
        
        cp 
      end

    end
    
  end
end
