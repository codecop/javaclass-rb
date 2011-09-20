require 'javaclass/classpath/java_home_classpath'
require 'javaclass/classpath/composite_classpath'

module JavaClass
  module Classpath

    # Factory methods to create different kind of classpaths.
    # Author::          Peter Kofler
    module Factory
      
      # Parse the given path variable _path_ and return a chain of class path elements.
      def classpath(path)
        full_classpath(nil, path)
      end
    
      # Parse and scan the system classpath. Needs +JAVA_HOME+ set. Uses environment +CLASSPATH+ if set.
      def environment_classpath
        full_classpath(ENV['JAVA_HOME'], ENV['CLASSPATH'])
      end
    
      # Parse the given path variable _path_ and return a chain of class path elements together with _javahome_ if any.
      # This creates a CompositeClasspath.
      def full_classpath(javahome, path='')
        cp = CompositeClasspath.new
        cp.add_element(JavaHomeClasspath.new(javahome)) if javahome
        path.split(File::PATH_SEPARATOR).each { |cpe| cp.add_file_name(cpe) } if path
        cp
      end
      
    end
    
  end
end
