require File.dirname(__FILE__) + '/setup'
require 'javaclass/dependencies/edge'

module TestJavaClass
  module TestDependencies
   
    class TestEdge < Test::Unit::TestCase
      include JavaClass::Dependencies
    
      def test_to_s
        assert_equal('target (source)', Edge.new('source', 'target').to_s)
      end

      def test_equals2_true
        edge1 = Edge.new('blue', 'ball')
        edge2 = Edge.new('blue', 'ball')
        assert(edge1 == edge2)
      end

      def test_equals2_false
        edge1 = Edge.new('blue', 'ball')
        edge2 = Edge.new('red', 'ball')
        edge3 = Edge.new('blue', 'balloon')
        assert(edge1 != edge2)
        assert(edge1 != edge3)
      end

      def test_spaceship_sort_of_list
        original_list = [
          Edge.new('2', 'b'),
          Edge.new('1', 'b'),
          Edge.new('2', 'a'),
          Edge.new('1', 'a')
        ].sort
        sorted_list = [
          Edge.new('1', 'a'),
          Edge.new('2', 'a'),
          Edge.new('1', 'b'),
          Edge.new('2', 'b')
        ]
          
        assert_equal(sorted_list, original_list.sort)
      end

      def test_hash_uniq_of_list
        original_list = [
          Edge.new('1', 'a'),
          Edge.new('1', 'a')
        ].sort
        uniq_list = [
          Edge.new('1', 'a')
        ]
          
        assert_equal(uniq_list, original_list.uniq)
      end

    end

  end
end
