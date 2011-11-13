# A simple add only tree. Once the tree is build if can't be changed. Only new elements can be added.
# Author::          Peter Kofler
class AdderTree

  attr_reader :parent
  attr_reader :data

  def initialize(data, parent=NullAdderTree.new)
    @data = data
    @parent = parent
    @children = []
  end

  def children
    @children.dup
  end

  def add(o)
    node = self.class.new(o, self)
    @children << node
    node
  end

  def below?(o)
    if @data == o
      self
    else
      @children.find { |child| child.below?(o) }
    end
  end

  def above?(o)
    if @data == o
      self
    else
      @parent.above?(o)
    end
  end

  def size
    @children.inject(1) { |sum, child| sum + child.size }
  end

  def levels
    ( [1] + @children.map { |child| 1 + child.levels } ).max
  end

  def to_a
    [ @data ] + @children.map { |child| child.to_a }
  end

end

class NullAdderTree # :nodoc:

  def children
    []
  end

  def below?(o)
    nil
  end

  def above?(o)
    nil
  end

  def size
    0
  end

  def levels
    0
  end

  def to_a
    [ ]
  end

end
