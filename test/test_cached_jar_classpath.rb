require File.dirname(__FILE__) + '/setup'
require 'javaclass/classpath/cached_jar_classpath'

module TestJavaClass
  module TestClasspath
    
    class TestCachedJarClasspath < Test::Unit::TestCase
      def setup
        @cpe = JavaClass::Classpath::CachedJarClasspath.new("#{TEST_DATA_PATH}/jar_classpath/JarClasspathTest.jar")
      end

      def test_load_binary
        assert_equal(load_class('class_version/ClassVersionTest10'), @cpe.load_binary('ClassVersionTest10'))
      end

    end

  end
end