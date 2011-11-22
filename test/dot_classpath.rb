module TestJavaClass
  module TestClasspath
   
    module DotClasspath
      def create_dot_classpath
        dot_classpath = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>
                        <classpath>
                            <classpathentry kind=\"src\" path=\"src\" />
                            <classpathentry kind=\"src\" path=\"test\" output=\"test-classes\" />
                            <classpathentry kind=\"con\" path=\"org.eclipse.jdt.launching.JRE_CONTAINER\" />
                            <classpathentry kind=\"lib\" path=\"lib/JarClasspathTest.jar\" />
                            <classpathentry kind=\"var\" path=\"TEST/jar_classpath/JarClasspathTest.zip\" />
                            <classpathentry kind=\"con\" path=\"org.eclipse.jdt.junit.JUNIT_CONTAINER/4\" />
                            <classpathentry kind=\"output\" path=\"classes\" />
                        </classpath>"
        File.open(dot_classpath_file, "w") { |f| f.print dot_classpath }
      end

      def dot_classpath_file
        File.join(eclipse_classpath, '.classpath')
      end

      def eclipse_classpath
        "#{TEST_DATA_PATH}/eclipse_classpath"
      end

      def remove_dot_classpath
        File.delete dot_classpath_file
      end
    end

  end
end