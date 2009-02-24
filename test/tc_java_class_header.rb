require File.dirname(__FILE__) + '/setup'
require 'javaclass/java_class_header'

class TestJavaClassHeader < Test::Unit::TestCase
  
  PUBLIC = File.expand_path("#{TEST_DATA_PATH}/PublicClass.class")
  PACKAGE = File.expand_path("#{TEST_DATA_PATH}/PackageClass.class")
  
  def setup
    @public = JavaClass::JavaClassHeader.new("PublicClass", File.open(PUBLIC, 'rb') {|io| io.read } )
    @package = JavaClass::JavaClassHeader.new("PackageClass", File.open(PACKAGE, 'rb') {|io| io.read } )
  end
  
  def test_header_valid
    assert(@public.valid?)
    assert(@package.valid?)
  end
  
  def test_version
    assert_equal('50.0', @public.version) # JDK 6
    assert_equal('50.0', @package.version)
  end
  
  def test_public
    assert(@public.accessible?)
    assert(!@package.accessible?)
  end
  
end
