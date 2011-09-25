require File.dirname(__FILE__) + '/setup'
require 'javaclass/classfile/java_class_header'
require 'javaclass/classfile/java_class_header_as_java_name'

module TestJavaClass
  module TestClassFile

    class TestJavaClassHeaderAsJavaName < Test::Unit::TestCase

      def setup
        @clazz = JavaClass::ClassFile::JavaClassHeader.new(load_class('access_flags/AccessFlagsTestPublic'))
      end

      def test_this_class
        assert_equal('packagename/AccessFlagsTestPublic', @clazz.this_class)
      end

      def test_to_classname
        assert_equal('packagename.AccessFlagsTestPublic', @clazz.to_classname)
      end

      def test_full_name
        assert_equal('packagename.AccessFlagsTestPublic', @clazz.full_name)
      end

      def test_package
        assert_equal('packagename', @clazz.package)
      end

      def test_simple_name
        assert_equal('AccessFlagsTestPublic', @clazz.simple_name)
      end

      def test_in_jdk_eh
        assert(!@clazz.in_jdk?)
      end

    end

  end
end