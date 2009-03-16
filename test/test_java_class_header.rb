require File.dirname(__FILE__) + '/setup'
require 'javaclass/java_class_header'

module TestJavaClass
  
  class TestJavaClassHeader < Test::Unit::TestCase
    
    def setup
      @public = JavaClass::JavaClassHeader.new(load_class("PublicClass"))
      @package = JavaClass::JavaClassHeader.new(load_class("PackageClass"))
    end
    
    def test_magic
      assert(@public.magic.valid?)
      assert(@package.magic.valid?)
    end
    
    def test_version
      assert_equal('50.0', @public.version.to_s) # JDK 6
      assert_equal('50.0', @package.version.to_s)
    end
    
    def test_this_class
      assert_equal('packagename/PublicClass', @public.this_class)
    end
    
    def test_super_class
      assert_equal('java/lang/Object', @public.super_class)
    end
    
    def test_accessible_eh
      assert(@public.accessible?)
      assert(!@package.accessible?)
    end
    
  end
  
end