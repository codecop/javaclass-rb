require File.dirname(__FILE__) + '/setup'
require 'javaclass/classpath/eclipse_classpath'

module TestJavaClass
  module TestClasspath

    class TestEclipseClasspath < Test::Unit::TestCase

      def setup
        @cpe = JavaClass::Classpath::EclipseClasspath.new("#{TEST_DATA_PATH}/eclipse_classpath")
      end

      def test_class_valid_location_eh
        assert(JavaClass::Classpath::EclipseClasspath.valid_location?("#{TEST_DATA_PATH}/eclipse_classpath"))
      end

      def test_class_valid_location_eh_invalid
        assert(!JavaClass::Classpath::EclipseClasspath.valid_location?("#{TEST_DATA_PATH}/folder_classpath"))
        assert(!JavaClass::Classpath::EclipseClasspath.valid_location?("#{TEST_DATA_PATH}/not_existing_folder"))
      end
            
      def test_count
        assert_equal(3, @cpe.count)
      end

      def test_elements
        assert_equal(2, @cpe.elements.size)
      end

      def test_includes_eh
        assert(@cpe.includes?('ClassVersionTest10.class'))
        assert(@cpe.includes?('package/ClassVersionTest11.class'))
        assert(@cpe.includes?('ClassVersionTest12.class'))
      end

    end

  end
end