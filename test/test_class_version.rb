require File.dirname(__FILE__) + '/setup'
require 'javaclass/class_version'

module TestJavaClass
  
  class TestClassVersion < Test::Unit::TestCase
    
    def setup
      @v = (0..6).collect do |i| 
        JavaClass::ClassVersion.new(load_class("ClassVersionTest1#{i}")) 
      end
    end
    
    # Assert the list of +v+ against the list of _expectations_ when invoking the given block.
    def assert_classes(expectations)
      expectations.values_at.each do |i|
        assert_equal(expectations[i], yield(@v[i]), "#{i}. element")
      end
    end
    
    def test_major
      assert_classes([45, 45, 46, 47, 48, 49, 50]) {|v| v.major}
    end
    
    def test_minor
      assert_classes([3, 3, 0, 0, 0, 0, 0]) {|v| v.minor}
      assert_equal(3, @v[1].minor) # shouldn't it be > 45.3  
    end
    
    def test_to_s
      assert_equal('50.0', @v[6].to_s)
      assert_equal('45.3', @v[0].to_s)
    end
    
    def test_to_f
      assert_equal(50.0, @v[6].to_f)
      assert_equal(45.3, @v[0].to_f)
      
      v = JavaClass::ClassVersion.new("....\000\xff\0002")
      assert_equal(50.255, v.to_f) 
      
      v = JavaClass::ClassVersion.new("....\xff\xff\0002")
      assert_equal(50.65535, v.to_f) 
    end
    
    def test_jdk_version
      assert_classes(%w[1.0 1.0 1.2 1.3 1.4 1.5 1.6]) {|v| v.jdk_version}
      
      v = JavaClass::ClassVersion.new("....\000\xff\0002")
      assert_equal('invalid', v.jdk_version)
    end
    
  end
  
end