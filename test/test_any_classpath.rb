require File.dirname(__FILE__) + '/setup'
require 'javaclass/classpath/any_classpath'

module TestJavaClass
  module TestClasspath

    class TestAnyClasspath < Test::Unit::TestCase

      def test_includes_eh
#        @cpe = JavaClass::Classpath::AnyClasspath.new(TEST_DATA_PATH)
#        # from folder
#        assert(@cpe.includes?('access_flags.AccessFlagsTestAbstract'))
#        # from jar, would have another package
#        assert(@cpe.includes?('packagename/PublicClass'))
#        # from jar, would have any package
#        assert(@cpe.includes?('ClassVersionTest10'))
      end

      def test_find_jars_direct
        @cpe = JavaClass::Classpath::AnyClasspath.new("#{TEST_DATA_PATH}/jar_classpath")
        assert_equal(4, @cpe.elements.size)
        assert_equal(File.expand_path("#{TEST_DATA_PATH}/jar_classpath/JarClasspathTest.zip"), @cpe.elements[1].to_s)
      end

      def test_find_jars_recursive
        @cpe = JavaClass::Classpath::AnyClasspath.new("#{TEST_DATA_PATH}/eclipse_classpath")
        assert_equal(1, @cpe.elements.size)
      end

      def test_find_jars_single
        @cpe = JavaClass::Classpath::AnyClasspath.new("#{TEST_DATA_PATH}/jar_classpath/JarClasspathTest.zip")
        assert_equal(1, @cpe.elements.size)
        assert_equal(File.expand_path("#{TEST_DATA_PATH}/jar_classpath/JarClasspathTest.zip"), @cpe.elements[0].to_s)
      end
      
    end

  end
end