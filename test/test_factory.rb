require File.dirname(__FILE__) + '/setup'
require 'javaclass/classpath/factory'

module TestJavaClass
  module TestClasspath

    class TestFactory < Test::Unit::TestCase
      include JavaClass::Classpath::Factory

      def test_full_classpath
        cp = full_classpath("#{TEST_DATA_PATH}/java_home_classpath/jre-ext",
        "#{TEST_DATA_PATH}/jar_classpath/JarClasspathTestManifest.jar#{File::PATH_SEPARATOR}#{TEST_DATA_PATH}/folder_classpath/JarClasspathTestFolder")
        elem = cp.elements
        assert_equal(5, elem.size)
        assert_equal("#{TEST_DATA_PATH}/java_home_classpath/jre-ext/lib/rt.jar", elem[0].to_s)
        assert_equal("#{TEST_DATA_PATH}/java_home_classpath/jre-ext/lib/ext/ext.jar", elem[1].to_s)
        assert_equal("#{TEST_DATA_PATH}/jar_classpath/JarClasspathTestManifest.jar", elem[2].to_s)
        assert_equal("#{TEST_DATA_PATH}/jar_classpath/JarClasspathTest.jar", elem[3].to_s)
        assert_equal("#{TEST_DATA_PATH}/folder_classpath/JarClasspathTestFolder", elem[4].to_s)
      end

    end

  end
end