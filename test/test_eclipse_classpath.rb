require File.dirname(__FILE__) + '/setup'
require 'javaclass/classpath/eclipse_classpath'

module TestJavaClass
  module TestClasspath

    # TODO save the .classpath file myself, it's not added to the ZIP, tests fail after download
    
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
        assert_equal(4, @cpe.count)
      end

      def test_elements
        assert_equal(3, @cpe.elements.size)
      end

      def test_includes_eh
        assert(@cpe.includes?('ClassVersionTest10.class'))
        assert(@cpe.includes?('package/ClassVersionTest11.class'))
        assert(@cpe.includes?('ClassVersionTest12.class'))
        assert(@cpe.includes?('ClassVersionTest13.class'))
      end

      def test_class_skip_lib
        JavaClass::Classpath::EclipseClasspath.skip_lib
        cpe = JavaClass::Classpath::EclipseClasspath.new("#{TEST_DATA_PATH}/eclipse_classpath")
        JavaClass::Classpath::EclipseClasspath.skip_lib(false)
        assert(!cpe.includes?('ClassVersionTest10.class'))
        assert(cpe.includes?('ClassVersionTest12.class'))
      end

      def test_class_add_variable
        begin
          JavaClass::Classpath::EclipseClasspath.add_variable("TEST", TEST_DATA_PATH)

          cpe = JavaClass::Classpath::EclipseClasspath.new("#{TEST_DATA_PATH}/eclipse_classpath")
          assert(cpe.includes?('ClassVersionTest10.class'))

        ensure
          JavaClass::Classpath::EclipseClasspath.add_variable("TEST", nil)
        end
      end
      
      def test_class_new_invalid
        assert_raise(IOError) {
          JavaClass::Classpath::EclipseClasspath.new("#{TEST_DATA_PATH}/folder_classpath")
        }
      end

    end

  end
end