require File.dirname(__FILE__) + '/logging_folder_classpath'
require 'javaclass/classpath/jar_classpath'

module JavaClass
  module Classpath

    # Add a method +used_unpacked_folder?+ to see if the load_binary of the unpacked folder was called.
    class JarClasspath

      # Helper method to assert it the cache was called.
      def used_unpacked_folder?
        result = @delegate.was_called
        @delegate.was_called = false # reset flag
        result
      end
    end

  end
end

module TestJavaClass
  module TestClasspath

    class TestUnpackingJarClasspath < Test::Unit::TestCase

      def setup
        JavaClass.unpack_jars!(true)
        @cpe = JavaClass::Classpath::JarClasspath.new("#{TEST_DATA_PATH}/jar_classpath/JarClasspathTest.jar")
      end

      def teardown
        JavaClass.unpack_jars!(false)
      end

      def test_load_binary
        assert_equal(load_class('class_version/ClassVersionTest10'), @cpe.load_binary('ClassVersionTest10'))
        assert(@cpe.used_unpacked_folder?)
      end

    end

  end
end
