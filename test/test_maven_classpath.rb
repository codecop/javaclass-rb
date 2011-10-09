require File.dirname(__FILE__) + '/setup'
require 'javaclass/classpath/maven_classpath'

module TestJavaClass
  module TestClasspath
   
    class TestMavenClasspath < Test::Unit::TestCase

      def setup
        @cpe = JavaClass::Classpath::MavenClasspath.new("#{TEST_DATA_PATH}/maven_classpath")
      end

      def test_class_valid_location_eh
        assert(JavaClass::Classpath::MavenClasspath.valid_location?("#{TEST_DATA_PATH}/maven_classpath"))
        assert(JavaClass::Classpath::MavenClasspath.valid_location?("#{TEST_DATA_PATH}/maven_classpath/module"))
      end

      def test_class_valid_location_eh_no_pom
        assert(!JavaClass::Classpath::MavenClasspath.valid_location?("#{TEST_DATA_PATH}/folder_classpath"))
        assert(!JavaClass::Classpath::MavenClasspath.valid_location?("#{TEST_DATA_PATH}/not_existing_folder"))
      end
      
      def test_count
        assert_equal(3, @cpe.count)
      end

      def test_elements
        assert_equal(3, @cpe.elements.size)
      end

      def test_includes_eh
        assert(@cpe.includes?('ClassVersionTest10.class'))
        assert(@cpe.includes?('ClassVersionTest11.class'))
        assert(@cpe.includes?('ClassVersionTest12.class'))
      end

      def test_class_new_invalid
        assert_raise(IOError) {
          JavaClass::Classpath::MavenClasspath.new("#{TEST_DATA_PATH}/folder_classpath")
        }
      end
      
    end

  end
end