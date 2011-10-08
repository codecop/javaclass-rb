require File.dirname(__FILE__) + '/setup'
require 'javaclass/classpath/factory'

module TestJavaClass
  module TestClasspath

    class TestFactory < Test::Unit::TestCase
      include JavaClass::Classpath::Factory

      def test_full_classpath
        cp = full_classpath("#{TEST_DATA_PATH}/java_home_classpath/jre-ext",
        "#{TEST_DATA_PATH}/jar_classpath/JarClasspathTestManifest.jar#{File::PATH_SEPARATOR}#{TEST_DATA_PATH}/folder_classpath/classes")
        elem = cp.elements
        assert_equal(5, elem.size)
        assert_equal("#{TEST_DATA_PATH}/java_home_classpath/jre-ext/lib/rt.jar", elem[0].to_s)
        assert_equal("#{TEST_DATA_PATH}/java_home_classpath/jre-ext/lib/ext/ext.jar", elem[1].to_s)
        assert_equal("#{TEST_DATA_PATH}/jar_classpath/JarClasspathTestManifest.jar", elem[2].to_s)
        assert_equal("#{TEST_DATA_PATH}/jar_classpath/JarClasspathTest.jar", elem[3].to_s)
        assert_equal("#{TEST_DATA_PATH}/folder_classpath/classes", elem[4].to_s)
      end

      def test_environment_classpath
        jh = ENV['JAVA_HOME']
        clp = ENV['CLASSPATH']
        begin
          ENV['JAVA_HOME'] = "#{TEST_DATA_PATH}/java_home_classpath/jdk"
          ENV['CLASSPATH'] = "#{TEST_DATA_PATH}/folder_classpath/classes"
            
          cp = environment_classpath
          elem = cp.elements 
          assert_equal(2, elem.size) # rt.jar and classes folder

        ensure
          ENV['JAVA_HOME'] = jh
          ENV['CLASSPATH'] = clp
        end 
      end
      
      def test_workspace_first_level
        cp = workspace("#{TEST_DATA_PATH}/maven_classpath")
        elem = cp.elements 
        assert_equal(3, elem.size) # 2+1 folder Maven
      end

      def test_workspace_second_level
        cp = workspace("#{TEST_DATA_PATH}")
        elem = cp.elements 
        assert_equal(7, elem.size) # 2 folder + 1 jar Eclipse, 2+1 folder Maven, folder plain
      end
      
    end

  end
end