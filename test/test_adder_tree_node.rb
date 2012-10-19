require File.dirname(__FILE__) + '/setup'
require 'javaclass/adder_tree'

class TestAdderTreeNode < Test::Unit::TestCase

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
    node = @tree.add(2)
    assert_equal([0, [1, 2]], @tree.to_a)

    node.add(3)
    assert_equal([0, [1, 2, [3]]], @tree.to_a)
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

  def test_contain_eh_itself
    assert(@tree.contain?(0))
    assert_nil(@tree.contain?(1))
  end

  def test_contain_eh
    assert_nil(@tree.contain?(1))
    @tree.add(1)
    assert(@tree.contain?(1))
  end

  def test_level
    assert_equal(0, @tree.level)
    node = @tree.add(1)
    assert_equal(0, @tree.level)
    assert_equal(1, node.level)
    node.add(2)
    assert_equal(1, node.level)
  end

  def test_root
    assert_equal(0, @tree.root.data)
    node = @tree.add(1)
    assert_equal(0, node.root.data)
  end

end
