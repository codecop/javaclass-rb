require File.dirname(__FILE__) + '/setup'
require 'javaclass/classpath/maven_classpath'

module TestJavaClass
  module TestClasspath
   
    class TestMavenClasspath < Test::Unit::TestCase
      def setup
        @cpe = JavaClass::Classpath::MavenClasspath.new("#{TEST_DATA_PATH}/maven_classpath")
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

    end

  end
end