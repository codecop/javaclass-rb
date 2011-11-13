require File.dirname(__FILE__) + '/setup'
require 'javaclass/adder_tree'

class TestAdderTree < Test::Unit::TestCase

  def setup
    @tree = AdderTree.new(0)
  end

  def test_data
    assert_equal(0, @tree.data)
  end

  def test_to_a
    assert_equal([0], @tree.to_a)
  end

  def test_add
    @tree.add(1)
    assert_equal([0, [1]], @tree.to_a)
  end

  def test_size
    assert_equal(1, @tree.size)
    @tree.add(1)
    assert_equal(2, @tree.size)
    @tree.add(2)
    assert_equal(3, @tree.size)
  end

  def test_levels
    assert_equal(1, @tree.levels)
    node = @tree.add(1)
    assert_equal(2, @tree.levels)
    node.add(2)
    assert_equal(3, @tree.levels)
  end

  def test_children
    assert_equal(0, @tree.children.size)
    @tree.add(1)
    assert_equal(1, @tree.children.size)

    assert_equal(1, @tree.children[0].data)
  end

  def test_below_eh_itself
    assert(@tree.below?(0))
    assert_nil(@tree.below?(1))
  end

  def test_below_eh
    assert_nil(@tree.below?(1))
    @tree.add(1)
    assert(@tree.below?(1))
  end

  def test_above_eh_itself
    assert(@tree.above?(0))
    assert_nil(@tree.above?(1))
  end

  def test_above_eh
    node = @tree.add(1)
    assert(node.above?(0))
  end

end
