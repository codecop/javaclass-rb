require File.dirname(__FILE__) + '/setup'
require 'javaclass/constants/base'

module TestJavaClass
  
  class TestConstantBase < Test::Unit::TestCase
    
    class ConstantClass < JavaClass::Constants::Base;
      def initialize(name=nil); super(name); end
    end
    
    def test_name
      v = ConstantClass.new
      assert_equal("Class", v.name)
      
      v = ConstantClass.new("Bubu")
      assert_equal("Bubu", v.name)
    end
    
  end
  
end
