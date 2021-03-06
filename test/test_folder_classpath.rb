require File.dirname(__FILE__) + '/setup'
require 'javaclass/classpath/folder_classpath'

module TestJavaClass
  module TestClasspath

    class TestFolderClasspath < Test::Unit::TestCase

      def setup
        @cpe = JavaClass::Classpath::FolderClasspath.new("#{TEST_DATA_PATH}/folder_classpath/classes")
      end

      def test_count
        assert_equal(2, @cpe.count)
      end

      def test_additional_classpath
        assert_equal([], @cpe.additional_classpath)
      end

      def test_jar_eh
        assert(!@cpe.jar?)
      end

      def test_includes_eh
        assert(@cpe.includes?('ClassVersionTest10.class'))
        assert(@cpe.includes?('ClassVersionTest10'))
        assert(!@cpe.includes?('ClassVersionTest11.class'))
        assert(!@cpe.includes?('ClassVersionTest11'))
        assert(@cpe.includes?('package/ClassVersionTest11.class'))
        assert(@cpe.includes?('package/ClassVersionTest11'))
      end

      def test_load_binary
        assert_equal(load_class('class_version/ClassVersionTest10'), @cpe.load_binary('ClassVersionTest10'))

        assert_raise(JavaClass::Classpath::ClassNotFoundError) {
          @cpe.load_binary('NonExistingClass')
        }
      end

      def test_names
        assert_equal(['ClassVersionTest10.class', 'package/ClassVersionTest11.class'], @cpe.names)
        assert_equal(['ClassVersionTest10.class'], @cpe.names { |n| n=~ /10/ })
      end

      def test_elements
        assert_equal(1, @cpe.elements.size)
        assert_equal(@cpe.to_s, @cpe.elements[0].to_s)
      end

      def test_class_new_invalid
        assert_raise(IOError) {
          JavaClass::Classpath::FolderClasspath.new("#{TEST_DATA_PATH}/jar_classpath/JarClasspathTest.jar")
        }
      end
      
    end unless defined? TestFolderClasspath
    
  end
end