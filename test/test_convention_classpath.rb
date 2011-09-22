require File.dirname(__FILE__) + '/setup'
require 'javaclass/classpath/convention_classpath'

module TestJavaClass
  module TestClasspath

    class TestConventionClasspath < Test::Unit::TestCase

      def setup
        @folder = "#{TEST_DATA_PATH}/eclipse_classpath"
        @cpe = JavaClass::Classpath::ConventionClasspath.new(@folder)
      end

      def test_class_valid_location_eh
        assert(JavaClass::Classpath::ConventionClasspath.valid_location?("#{TEST_DATA_PATH}/eclipse_classpath"))
        assert(JavaClass::Classpath::ConventionClasspath.valid_location?("#{TEST_DATA_PATH}/folder_classpath"))
      end

      def test_class_valid_location_eh_no_pom
        assert(!JavaClass::Classpath::ConventionClasspath.valid_location?("#{TEST_DATA_PATH}/jar_classpath"))
        assert(!JavaClass::Classpath::ConventionClasspath.valid_location?("#{TEST_DATA_PATH}/not_existing_folder"))
      end

      def test_count
        assert_equal(1, @cpe.count)
      end

      def test_additional_classpath
        assert_equal(["#{@folder}/lib/JarClasspathTest.jar"], @cpe.additional_classpath)
      end

      def test_includes_eh
        assert(@cpe.includes?('ClassVersionTest12.class'))
      end

    end

  end
end