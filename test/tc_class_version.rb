require File.dirname(__FILE__) + '/setup'
require 'javaclass/class_version'

module TestJavaClass
  
  class TestClassVersion < Test::Unit::TestCase
    
    def test_to_f
      v = JavaClass::ClassVersion.new("....\000\000\0002")
      assert_equal(50.0, v.to_f)
      
      v = JavaClass::ClassVersion.new("....\000\xff\0002")
      assert_equal(50.255, v.to_f) 
      
      v = JavaClass::ClassVersion.new("....\xff\xff\0002")
      assert_equal(50.65535, v.to_f) 
    end
    
    def test_jdk_version
      v = JavaClass::ClassVersion.new("....\000\003\000-")
      assert_equal('1.0', v.jdk_version)
      
      v = JavaClass::ClassVersion.new("....\000\000\0002")
      assert_equal('1.6', v.jdk_version)
      
      v = JavaClass::ClassVersion.new("....\000\xff\0002")
      assert_equal('invalid', v.jdk_version)
    end
    
  end
  
end