require File.dirname(__FILE__) + '/setup'
require 'javaclass/classfile/constants/base'

module TestJavaClass
  module TestClassFile
    module TestConstants
      
      class TestConstantBase < Test::Unit::TestCase
        
        class ConstantClass < JavaClass::ClassFile::Constants::Base; # ZenTest SKIP
          def initialize(name=nil); super(name); end
        end
        
        def test_name
          v = ConstantClass.new
          assert_equal("Class", v.name)
          
          v = ConstantClass.new("Bubu")
          assert_equal("Bubu", v.name)
        end
        
        def test_dump
          # TODO raise NotImplementedError, 'Need to write test_dump'
        end
        
        def test_size
          # TODO raise NotImplementedError, 'Need to write test_size'
        end
        
        def test_slots
          # TODO raise NotImplementedError, 'Need to write test_slots'
        end
        
        def test_tag
          # TODO raise NotImplementedError, 'Need to write test_tag'
        end
        
      end
      
    end
  end
end

