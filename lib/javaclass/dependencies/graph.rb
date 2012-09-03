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

          node.dependency_names.each do |dependency|
            providers = nodes_satisfying(dependency)
            node.add_dependency_to(dependency, providers)
          end
          
        end
      end
      
      # Find the nodes that satisfy the given _dependency_
      def nodes_satisfying(dependency)
        @nodes.find_all { |n| n.satisfies?(dependency) }
      end      
      
    end

  end
end