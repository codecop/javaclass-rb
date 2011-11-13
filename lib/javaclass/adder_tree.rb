# A simple add only tree. Once the tree is build if can't be changed. Only new elements can be added.
# Author::          Peter Kofler
class AdderTreeNode

  attr_reader :parent
  attr_reader :data

  def initialize(data, parent)
    @data = data
    @parent = parent
    @children = []
  end

  def children
    @children.dup
  end

  def add(o)
    node = AdderTreeNode.new(o, self)
    @children << node
    node
  end

  def contain?(o)
    if @data == o
      self
    else
      @children.find { |child| child.contain?(o) }
    end
  end

  def level
    @parent.level + 1
  end

  def root
    @parent.root
  end

  def size
    @children.inject(1) { |sum, child| sum + child.size }
  end

  def levels
    ( [1] + @children.map { |child| 1 + child.levels } ).max
  end

  def to_a
    if @children.size > 0
      sublist = []
      @children.each { |child| child.to_a.each { |c| sublist << c } } 
      [data, sublist]
    else
      [data]
    end
  end

  def debug_print
    puts ' ' * level + data
    @children.each { |child| child.debug_print }
  end
  
end

# The root node of the adder tree.
class AdderTree < AdderTreeNode

  attr_reader :parent
  attr_reader :data

  def initialize(data)
    super(data, nil)
  end

  def level
    0
  end

  def root
    self
  end

end
