require File.expand_path(File.dirname(__FILE__) + '/jar_classpath')

module JavaClass
  module Classpath # :nodoc:
    
    # Abstraction of the Java boot CLASSPATH. 
    # Author::   Peter Kofler
    class JavaHomeClasspath < JarClasspath
      
      # Return the list of classnames found in this _javahome_ . 
      def initialize(javahome)
        @javahome = javahome
        # TODO seatch for rt.jar, invoke super
      end
      
      # Return list of additional classpath elements relative to this javahome.
      def additional_classpath
        found = super
        # TODO search ext folder for endorsed jars and return full names
        found
      end
      
    end
    
  end
end