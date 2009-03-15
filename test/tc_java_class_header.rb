require File.dirname(__FILE__) + '/setup'
require 'javaclass/java_class_header'

module TestJavaClass
  
  class TestJavaClassHeader < Test::Unit::TestCase
    
    PUBLIC = File.expand_path("#{TEST_DATA_PATH}/PublicClass.class")
    PACKAGE = File.expand_path("#{TEST_DATA_PATH}/PackageClass.class")
    
    def setup
      @public = JavaClass::JavaClassHeader.new(File.open(PUBLIC, 'rb') {|io| io.read } )
      @package = JavaClass::JavaClassHeader.new(File.open(PACKAGE, 'rb') {|io| io.read } )
    end
    
    def test_magic
      assert(@public.magic.valid?)
      assert(@package.magic.valid?)
    end
    
    def test_version
      assert_equal('50.0', @public.version.to_s) # JDK 6
      assert_equal('50.0', @package.version.to_s)
    end
    
    def test_accessible_eh
      assert(@public.accessible?)
      assert(!@package.accessible?)
    end
    
  end
  
end