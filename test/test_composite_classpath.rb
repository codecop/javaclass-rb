require File.dirname(__FILE__) + '/setup'
require 'javaclass/classpath/composite_classpath'

module TestJavaClass
  module TestClasspath

    class TestCompositeClasspath < Test::Unit::TestCase

      def setup
        @cpe = JavaClass::Classpath::CompositeClasspath.new
        @cpe.add_file_name "#{TEST_DATA_PATH}/jar_classpath/JarClasspathTestManifest.jar"
      end

      def test_add_element
        # fake methods for zentest, tested in setup and add_file_name
        assert(true)
      end

      def test_add_file_name
        @cpe.add_file_name "#{TEST_DATA_PATH}/folder_classpath/JarClasspathTestFolder"
        assert_equal(2+1+2, @cpe.count)
      end

      def test_additional_classpath
        assert_equal([], @cpe.additional_classpath)
      end

      def test_jar_eh
        assert(!@cpe.jar?)
      end

      def test_count
        assert_equal(2+1, @cpe.count)
      end

      def test_elements
        assert_equal(2, @cpe.elements.size)
        assert_equal("#{TEST_DATA_PATH}/jar_classpath/JarClasspathTest.jar", @cpe.elements[1].to_s)
      end

      def test_includes_eh
        assert(@cpe.includes?('ClassVersionTest11.class'))
        assert(@cpe.includes?('ClassVersionTest11'))
        assert(@cpe.includes?('ClassVersionTest10.class'))
        assert(@cpe.includes?('ClassVersionTest10'))
      end

      def test_load_binary
        assert_equal(load_class('class_version/ClassVersionTest11'), @cpe.load_binary('ClassVersionTest11'))
        assert_equal(load_class('class_version/ClassVersionTest10'), @cpe.load_binary('ClassVersionTest10'))
        assert_equal(load_class('class_version/ClassVersionTest11'), @cpe.load_binary('package/ClassVersionTest11.class'))
      end

      def test_names
        assert_equal(['ClassVersionTest11.class', 'ClassVersionTest10.class', 'package/ClassVersionTest11.class'], @cpe.names)
      end

      def test_find_jars
        @cpe = JavaClass::Classpath::CompositeClasspath.new
        @cpe.find_jars("#{TEST_DATA_PATH}/jar_classpath")
        assert_equal(4, @cpe.elements.size)
        assert_equal(File.expand_path("#{TEST_DATA_PATH}/jar_classpath/JarClasspathTest.zip"), @cpe.elements[1].to_s)
      end

    end

  end
end