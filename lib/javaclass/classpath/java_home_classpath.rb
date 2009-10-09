require 'javaclass/classpath/jar_classpath'

module JavaClass
  module Classpath # :nodoc:
    
    # Abstraction of the Java boot CLASSPATH. May return additional classpath elements for endorsed libs. 
    # Author::   Peter Kofler
    class JavaHomeClasspath < JarClasspath
      
      # Return the list of classnames found in this _javahome_ . 
      def initialize(javahome)
        if FileTest.exist? rtjar=File.join(javahome, 'lib', 'rt.jar')
          super(rtjar)
        elsif FileTest.exist? rtjar=File.join(javahome, 'jre', 'lib', 'rt.jar')
          super(rtjar)
        else
          raise IOError, "rt.jar not found in java home #{javahome}"
        end
        @lib = File.dirname(rtjar)
      end
      
      # Return list of additional classpath elements, e.g. endorsed libs found in this Java Home.
      def additional_classpath
        list = super
        
        if FileTest.exist? ext=File.join(@lib, 'ext') 
          current = Dir.getwd
          Dir.chdir ext
          
          list += Dir['*.jar'].collect { |jar| File.join(ext, jar) }
          
          Dir.chdir current
        end
        list
      end
      
    end
    
  end
end