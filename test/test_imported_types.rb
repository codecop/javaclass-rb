require File.dirname(__FILE__) + '/setup'
require 'javaclass/classfile/java_class_header'
require 'javaclass/classscanner/imported_types'

module TestJavaClass

  module TestClassScanner

    class TestImportedTypes < Test::Unit::TestCase

      def setup
        @public = JavaClass::ClassScanner::ImportedTypes.new(
          JavaClass::ClassFile::JavaClassHeader.new(
            load_class('access_flags/AccessFlagsTestPublic')))
      end
      
      def test_imported_types
        types = ['java.lang.Object', 
        'packagename.AccessFlagsTestPublic$Inner', 
        'packagename.AccessFlagsTestPublic$InnerInterface', 
        'packagename.AccessFlagsTestPublic$StaticInner', ]
        assert_equal(types, @public.imported_types)
        assert_equal(types, @public.imported_types)
      end

    end

  end
end
