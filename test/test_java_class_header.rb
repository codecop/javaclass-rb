require File.dirname(__FILE__) + '/setup'
require 'javaclass/classfile/java_class_header'

module TestJavaClass
  module TestClassFile
    
    class TestJavaClassHeader < Test::Unit::TestCase
      
      def setup
        @public = JavaClass::ClassFile::JavaClassHeader.new(load_class('access_flags/AccessFlagsTestPublic'))
      end
      
      def test_magic
        assert(@public.magic.valid?)
      end
      
      def test_version
        assert_equal('50.0', @public.version.to_s) # JDK 6
      end
      
      def test_this_class
        assert_equal('packagename/AccessFlagsTestPublic', @public.this_class)
      end
      
      def test_super_class
        assert_equal('java/lang/Object', @public.super_class)
      end
      
      def test_dump
        expected = File.open("#{TEST_DATA_PATH}/access_flags/AccessFlagsTestPublic_javap.txt", 'r') {|io| io.read }
        assert_equal(expected.gsub(/\s+/, ' ').gsub(/"</, '<').gsub(/>"/, '>'), @public.dump.join("\n").gsub(/\s+/, ' '))
      end
      
      # --- fake methods for zentest, tested in separate test case ---
      def test_access_flags; assert(true); end
      def test_constant_pool() assert(true); end
      def test_references() assert(true); end
      
    end
    
  end
end