require 'javaclass/classpath/jar_classpath'

module JavaClass
  module Classpath

    # Abstraction of the Java boot CLASSPATH. May return additional classpath 
    # elements for endorsed libs. This is a leaf in the classpath tree.
    # Author::   Peter Kofler
    class JavaHomeClasspath < JarClasspath

      RT_JAR = 'rt.jar'
      
      # Create a classpath from this _javahome_ directory.
      def initialize(javahome)
        if exist?(rtjar=File.join(javahome, 'lib', RT_JAR))
          super(rtjar)
        elsif exist?(rtjar=File.join(javahome, 'jre', 'lib', RT_JAR))
          super(rtjar)
        elsif exist?(rtjar=File.join(javahome, 'lib', 'classes.zip')) # Java 1.1 home with lib/classes.zip
          super(rtjar)
        else
          raise IOError, "#{RT_JAR} not found in java home #{javahome}"
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

      private
      
      def exist?(file)
        FileTest.exist?(file) && FileTest.file?(file)
      end
      
    end

  end
end