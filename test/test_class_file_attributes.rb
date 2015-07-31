require File.dirname(__FILE__) + '/setup'
require 'javaclass/classfile/java_class_header'

module TestJavaClass
  module TestClassFile

    class TestClassFileAttributes < Test::Unit::TestCase

      def setup
        %w[Public Public$Inner Public$StaticInner Public$InnerInterface Enum$1 Anonym$1].each do |t|
          binary_data = load_class("access_flags/AccessFlagsTest#{t}")
          clazz = JavaClass::ClassFile::JavaClassHeader.new(binary_data)
          variable_name = t.sub(/Public\$/, 'public_').
                            sub(/Anonym\$1/, 'anonymous').
                            sub(/Enum\$1/,  'enum_inner').
                            downcase
          eval("@#{variable_name} = clazz.attributes")
        end
      end

      def test_inner_eh
        assert(!@public.inner?)
        assert(@public_inner.inner?)
        assert(@anonymous.inner?)
        assert(@enum_inner.inner?)
      end

      def test_source_file
        assert_equal('AccessFlagsTestPublic.java', @public.source_file)
        assert_equal('AccessFlagsTestPublic.java', @public_inner.source_file)
      end
    end

  end
end