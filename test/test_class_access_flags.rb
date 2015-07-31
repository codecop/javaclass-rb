require File.dirname(__FILE__) + '/setup'
require 'javaclass/classfile/java_class_header'

module TestJavaClass
  module TestClassFile

    class TestClassAccessFlags < Test::Unit::TestCase

      def setup
        %w[Public Package Abstract Interface Final Enum Annotation
           Public$InnerInterface Enum$1].each do |t|
          binary_data = load_class("access_flags/AccessFlagsTest#{t}")
          clazz = JavaClass::ClassFile::JavaClassHeader.new(binary_data)
          variable_name = t.sub(/Public\$/, 'public_').
                            sub(/Enum\$1/,  'enum_inner').
                            downcase
          eval("@#{variable_name} = clazz.access_flags")
        end
      end

      def test_flags_hex
        assert_equal('0021', @public.flags_hex)
        assert_equal('0020', @package.flags_hex)
      end

      def test_accessible_eh
        assert(@public.accessible?)
        assert(!@package.accessible?)
      end

      def test_public_eh
        assert(@public.public?)
        assert(!@package.public?)
      end

      def test_interface_eh
        assert(!@public.interface?)
        assert(!@abstract.interface?)
        assert(@interface.interface?)
        assert(@public_innerinterface.interface?)
        assert(@annotation.interface_flag?)
        assert(!@annotation.interface?)
      end

      def test_abstract_eh
        assert(!@public.abstract?)
        assert(@abstract.abstract?)
        assert(@interface.abstract?)
        assert(@public_innerinterface.abstract?)
        assert(@annotation.abstract?)
      end

      def test_final_eh
        assert(!@public.final?)
        assert(!@abstract.final?)
        assert(!@interface.final?)
        assert(@final.final?)
        assert(!@enum.final?) # because we have a inner class
        assert(@enum_inner.final?)
      end

      def test_enum_eh
        assert(!@public.enum?)
        assert(@enum.enum?)
        assert(@enum_inner.enum?)
      end

      def test_annotation_eh
        assert(!@public.annotation?)
        assert(!@public_innerinterface.annotation?)
        assert(!@interface.annotation?)
        assert(@annotation.annotation?)
      end
      
      def test_class_new_jdk10_fix
        flags = JavaClass::ClassFile::JavaClassHeader.new(load_class('Runnable_102')).access_flags
        assert(flags.abstract?)
        assert(flags.interface?)
      end
      
    end

  end
end