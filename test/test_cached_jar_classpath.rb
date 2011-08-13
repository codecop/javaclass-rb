require File.dirname(__FILE__) + '/setup'
require 'javaclass/classpath/folder_classpath'
require 'javaclass/classpath/jar_classpath'

module JavaClass
  module Classpath

    class FolderClasspath
      alias :__old_load_binary :load_binary

      def load_binary(classname)
        @was_called = true
        __old_load_binary(classname)
      end
      attr_accessor :was_called
    end

    class JarClasspath

      # Helper method to assert it the cache was called.
      def used_folder?
        result = @delegate.was_called
        @delegate.was_called = false # reset flag
        result
      end
    end

  end
end

module TestJavaClass
  module TestClasspath

    class TestCachedJarClasspath < Test::Unit::TestCase

      def setup
        JavaClass.unpack_jars!(true)
        @cpe = JavaClass::Classpath::JarClasspath.new("#{TEST_DATA_PATH}/jar_classpath/JarClasspathTest.jar")
      end

      def teardown
        JavaClass.unpack_jars!(false)
      end

      def test_load_binary
        assert_equal(load_class('class_version/ClassVersionTest10'), @cpe.load_binary('ClassVersionTest10'))
        assert(@cpe.used_folder?)
      end

    end

  end
end