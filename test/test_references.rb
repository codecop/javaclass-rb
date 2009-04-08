require File.dirname(__FILE__) + '/setup'
require 'javaclass/java_class_header'

module TestJavaClass
  
  class TestReferences < Test::Unit::TestCase
    
    def setup
      @refs = JavaClass::JavaClassHeader.new(load_class("AccessFlagsTestPublic")).references
    end
    
    def test_referenced_fields
      fields = @refs.referenced_fields(false)
      assert_equal(0, fields.size)
    end
    
    def test_referenced_methods
      methods = @refs.referenced_methods(false)
      assert_equal(1, methods.size) # ctor init
      assert_equal('java/lang/Object', methods[0].class_name)
      
      # TODO test with myself (true)...
    end
    
    # TODO test referenced classes
    
  end
  
end