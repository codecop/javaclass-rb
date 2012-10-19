require File.dirname(__FILE__) + '/setup'
require 'javaclass/dependencies/node'

module TestJavaClass
  module TestDependencies
    
    class TestNode < Test::Unit::TestCase
      
      def setup
        @node = JavaClass::Dependencies::Node.new('someNode')
        @other = JavaClass::Dependencies::Node.new('otherNode', 1)
      end

      def test_to_s
        assert_equal('someNode', @node.to_s)
        assert_equal('otherNode (1)', @other.to_s)
      end

      def test_size
        assert_equal(1, @other.size)
      end
      
      def test_add_dependency_to_for_unsatisfied
        @node.add_dependency('dependency.for.another.node', [])
        assert_equal(0, @node.dependencies().size)
      end

      def test_add_dependency_to_for_found
        @node.add_dependency('dependency.for.other.node', [@other])
        assert_equal(1, @node.dependencies().size)
        assert_equal(['dependency.for.other.node'], @node.dependencies[@other])
      end

      def test_equal
        assert_equal(@node, @node)
        assert_equal(@node, JavaClass::Dependencies::Node.new('someNode'))
        assert_not_equal(@node, @other)
      end

      def test_hash
        assert_equal(@node.hash, @node.hash)
        assert_equal(@node.hash, JavaClass::Dependencies::Node.new('someNode').hash)
      end

      def test_each_dependency_provider
        # TODO 'Need to write test_each_dependency_provider'
      end

      def test_each_edge
        # TODO 'Need to write test_each_edge'
      end
      
    end

  end
end