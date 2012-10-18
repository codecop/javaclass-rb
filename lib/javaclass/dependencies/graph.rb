module JavaClass
  
  # The module Dependencies is for separating namespaces. It contains logic 
  # to analyse and structure general dependencies. A set of dependencies build
  # a Graph which can be analaysed.
  # Author::          Peter Kofler
  module Dependencies
   
    # A graph contains a list of Node
    # Author::          Peter Kofler
    class Graph

      def initialize
        @nodes = []
      end

      # Add a _node_ to this graph.
      def add(node)
        @nodes << node
      end

      def to_a
        @nodes.dup
      end

      # Iterates all nodes and fills the dependency fields of the Node.
      def resolve_dependencies
        @nodes.each do |node|
          puts "processing #{node}"

          node.outgoing_dependencies do |dependency|
            providers = nodes_satisfying(dependency.target)
            node.add_dependency(dependency, providers)
          end
          
          node.dependencies.values.each { |vals| vals.sort! }
        end
      end
      
      # Find the nodes that satisfy the given _dependency_
      def nodes_satisfying(dependency)
        @nodes.find_all { |n| n.satisfies?(dependency) }
      end      

      # Iterate all nodes in this Graph and call _block_ for each Node 
      def each_node(&block)
        @nodes.each { |node| block.call(node) }
      end      
      
    end

  end
end