require File.dirname(__FILE__) + '/setup'
require 'javaclass/dependencies/node'

module TestJavaClass
  module TestDependencies
    
    class TestNode < Test::Unit::TestCase
      
      def setup
        @node = JavaClass::Dependencies::Node.new('someNode')
        @other = JavaClass::Dependencies::Node.new('otherNode')
      end

      def test_to_s
        assert_equal('someNode', @node.to_s)
      end

      def test_add_dependency_to_for_unsatisfied
        @node.add_dependency_to('dependency.for.another.node', [])
        assert_equal(0, @node.dependencies().size)
      end

      def test_add_dependency_to_for_found
        @node.add_dependency_to('dependency.for.other.node', [@other])
        assert_equal(1, @node.dependencies().size)
        assert_equal(['dependency.for.other.node'], @node.dependencies[@other])
      end

    end

  end
end