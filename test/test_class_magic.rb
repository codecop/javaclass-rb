require File.dirname(__FILE__) + '/setup'
require 'javaclass/classfile/class_magic'

module TestJavaClass
  module TestClassFile

    class TestClassMagic < Test::Unit::TestCase

      def setup
        @magic = JavaClass::ClassFile::ClassMagic.new(load_class('Object_102'))
      end

      def test_valid_eh
        assert(@magic.valid?)
      end

      def test_bytes
        assert_equal("\xCA\xFE\xBA\xBE", @magic.bytes)
      end

    end

  end
end