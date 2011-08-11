require File.dirname(__FILE__) + '/setup'
require 'javaclass/classfile/constants/base'

module TestJavaClass
  module TestClassFile
    module TestConstants

      class TestBase < Test::Unit::TestCase

        class ConstantClass < JavaClass::ClassFile::Constants::Base; # ZenTest SKIP mock class
          def initialize(name=nil)
            super(name)
          end
        end

        def test_name
          v = ConstantClass.new
          assert_equal('Class', v.name)

          v = ConstantClass.new('Bubu')
          assert_equal('Bubu', v.name)
        end

      end

    end
  end
end

