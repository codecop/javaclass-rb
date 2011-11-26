# A node in the AdderTree. 
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

  # Return the number of nodes this this (sub-)tree.
  def size
    @children.inject(1) { |sum, child| sum + child.size }
  end

  def levels
    ( [1] + @children.map { |child| 1 + child.levels } ).max
  end

  # Return an array of all children. Each child has its own array. For example
  #  tree = AdderTree.new(0)
  #  tree.add(1)
  #  tree.to_a               # => [0, [1]]
  def to_a
    if @children.size > 0
      sublist = []
      @children.each { |child| child.to_a.each { |c| sublist << c } } 
      [data, sublist]
    else
      [data]
    end
  end

  # Prints the tree to the console. Each level of the tree is intended by a blank.
  def debug_print
    puts ' ' * level + data
    @children.each { |child| child.debug_print }
  end
  
end

# The root node of the adder tree. The "adder tree" is a simple add-only tree. 
# Once the tree is build it can't be changed. Only new elements can be added. 
# The tree's main functionality is defined in AdderTreeNode.
# Author::          Peter Kofler
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
