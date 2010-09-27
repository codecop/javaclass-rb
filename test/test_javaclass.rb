require File.dirname(__FILE__) + '/setup'
require 'javaclass'

module TestJavaClass
  
  class TestSelf < Test::Unit::TestCase
    def test_parse
      cp = JavaClass.classpath("#{TEST_DATA_PATH}/java_home_classpath/jre-ext",
      "#{TEST_DATA_PATH}/jar_classpath/JarClasspathTestManifest.jar#{File::PATH_SEPARATOR}#{TEST_DATA_PATH}/folder_classpath/JarClasspathTestFolder")
      elem = cp.elements
      assert_equal(5, elem.size)
      assert_equal("#{TEST_DATA_PATH}/java_home_classpath/jre-ext/lib/rt.jar", elem[0].to_s)
      assert_equal("#{TEST_DATA_PATH}/java_home_classpath/jre-ext/lib/ext/ext.jar", elem[1].to_s)
      assert_equal("#{TEST_DATA_PATH}/jar_classpath/JarClasspathTestManifest.jar", elem[2].to_s)
      assert_equal("#{TEST_DATA_PATH}/jar_classpath/JarClasspathTest.jar", elem[3].to_s)
      assert_equal("#{TEST_DATA_PATH}/folder_classpath/JarClasspathTestFolder", elem[4].to_s)
    end

    def test_class_classpath
      # TODO raise NotImplementedError, 'Need to write test_class_classpath'
    end

    def test_class_system_classpath
      # TODO raise NotImplementedError, 'Need to write test_class_system_classpath'
    end

  end

end