require File.dirname(__FILE__) + '/setup'
require 'javaclass/classfile/java_class_header'

module TestJavaClass
  module TestClassFile

    class TestReferences < Test::Unit::TestCase

      def setup
        @refs = JavaClass::ClassFile::JavaClassHeader.new(load_class('references/ReferencesTest')).references
      end

      def test_referenced_fields
        fields = @refs.referenced_fields
        assert_equal(0, fields.size)

        fields = @refs.referenced_fields(:include_own)
        assert_equal(1, fields.size)
        assert_equal('ReferencesTest', fields[0].class_name)
        assert_equal('ReferencesTest', fields[0].class_name.to_classname)
        assert_equal('field:LReferencesTest;', fields[0].signature)
      end

      def test_referenced_methods
        methods = @refs.referenced_methods
        assert_equal(1, methods.size) # ctor init
        assert_equal('java/lang/Object', methods[0].class_name)
        assert_equal('java.lang.Object', methods[0].class_name.to_classname)

        methods = @refs.referenced_methods(:include_own)
        assert_equal(2, methods.size)
        assert_equal('java/lang/Object', methods[0].class_name)
        assert_equal('ReferencesTest', methods[1].class_name)
        assert_equal('x:()V', methods[1].signature)
      end

      def test_used_classes
        classes = @refs.used_classes
        assert_equal(1, classes.size)
        assert_equal('java/lang/Object', classes[0].class_name)
        assert_equal('java.lang.Object', classes[0].class_name.to_classname)
      end

    end

  end
end