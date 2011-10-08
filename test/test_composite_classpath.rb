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
        @cpe.add_file_name "#{TEST_DATA_PATH}/folder_classpath/classes"
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
        assert_equal("#{TEST_DATA_PATH}/jar_classpath/JarClasspathTestManifest.jar", @cpe.elements[0].to_s)
        assert_equal("#{TEST_DATA_PATH}/jar_classpath/JarClasspathTest.jar", @cpe.elements[1].to_s)
      end

      def test_includes_eh
        assert(@cpe.includes?('ClassVersionTest11.class'))
        assert(@cpe.includes?('ClassVersionTest11'))
        assert(@cpe.includes?('ClassVersionTest10.class'))
        assert(@cpe.includes?('ClassVersionTest10'))
      end

      def test_load_binary
        # JarClasspathTestManifest.jar
        assert_equal(load_class('class_version/ClassVersionTest11'), @cpe.load_binary('package/ClassVersionTest11.class'))
        # JarClasspathTest.jar
        assert_equal(load_class('class_version/ClassVersionTest11'), @cpe.load_binary('ClassVersionTest11'))
        assert_equal(load_class('class_version/ClassVersionTest10'), @cpe.load_binary('ClassVersionTest10'))
          
        assert_raise(JavaClass::Classpath::ClassNotFoundError) { @cpe.load_binary('NonExisting') }
      end

      def test_names
        assert_equal(['ClassVersionTest11.class', 'ClassVersionTest10.class', 'package/ClassVersionTest11.class'], @cpe.names)
        assert_equal(['ClassVersionTest11.class', 'package/ClassVersionTest11.class'], @cpe.names { |n| n=~ /11/ })
      end

      def test_find_jars_direct
        @cpe = JavaClass::Classpath::CompositeClasspath.new
        @cpe.find_jars("#{TEST_DATA_PATH}/jar_classpath")
        assert_equal(4, @cpe.elements.size)
        assert_equal(File.expand_path("#{TEST_DATA_PATH}/jar_classpath/JarClasspathTest.zip"), @cpe.elements[1].to_s)
      end

      def test_find_jars_recursive
        @cpe = JavaClass::Classpath::CompositeClasspath.new
        @cpe.find_jars("#{TEST_DATA_PATH}/eclipse_classpath")
        assert_equal(1, @cpe.elements.size)
      end

      def test_find_jars_single
        @cpe = JavaClass::Classpath::CompositeClasspath.new
        @cpe.find_jars("#{TEST_DATA_PATH}/jar_classpath/JarClasspathTest.zip")
        assert_equal(1, @cpe.elements.size)
        assert_equal(File.expand_path("#{TEST_DATA_PATH}/jar_classpath/JarClasspathTest.zip"), @cpe.elements[0].to_s)
      end
      
    end unless defined? TestCompositeClasspath

  end
end
