require File.dirname(__FILE__) + '/setup'
require 'javaclass/java_class_header'

module TestJavaClass
  
  class TestJavaClassHeader < Test::Unit::TestCase
    
    def setup
      @public = JavaClass::JavaClassHeader.new(load_class("AccessFlagsTestPublic"))
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
    
    def test_access_flags
      # method only for autotest, tested in separate test case
      assert(true)
    end
    
    # TODO
#    def test_dump
#      raise NotImplementedError, 'Need to write test_dump'
#    end
    
    # --- fake methods for zentest ---
    def test_constant_pool() assert(true); end
    def test_references() assert(true); end
    
  end
  
end