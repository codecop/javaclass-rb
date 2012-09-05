require 'yaml'
require 'javaclass/dependencies/edge'
require 'javaclass/dependencies/node'
require 'javaclass/dependencies/graph'

module JavaClass
  module Dependencies
    
    # Serializes a Graph of Nodes to YAML.
    # Author::          Peter Kofler
    class YamlSerializer
      
      # Save the _graph_ to YAML _filename_
      def save(filename, graph)
        File.open(filename + '.yaml', 'w') { |f| f.print graph_to_yaml(graph) }
      end

      # Return a String of the YAML serialitzed _graph_
      def graph_to_yaml(graph)
        "---\n" +
        graph.to_a.map { |node| node_to_yaml(node) }.join("\n")
      end

      # Return a String of the YAML serialitzed _node_
      def node_to_yaml(node)
        node.name + ":\n" +
        node.dependencies.keys.map { |dep|
          '  ' + dep.name + ":\n" + dependencies_to_yaml(node.dependencies[dep])
        }.join("\n")
      end

      private

      def dependencies_to_yaml(dependencies)
        dependencies.map { |dep| "    - #{dep.source}->#{dep.target}" }.join("\n")
      end

      def node_with(name)
        node = @nodes_by_name[name]
        if node
          node
        else
          @nodes_by_name[name] = Node.new(name)
        end
      end

      public

      # Save the _graph_ from YAML _filename_
      def load(filename)
        yaml = YAML.load_file(filename + '.yaml')
        yaml_to_graph(yaml)
      end
      
      # Return a Graph from the YAML data _yaml_
      def yaml_to_graph(yaml)
        graph = Graph.new
        @nodes_by_name = {}

        yaml.keys.each do |name|
          node = node_with(name)
          graph.add(node)

          dependency_map = yaml[name] || {}
          dependency_map.keys.each do |dependency_name|
            depending_node = node_with(dependency_name)
            dependencies = dependency_map[dependency_name].collect { |d| Edge.new(*d.split(/->/)) }
            node.add_dependencies(dependencies, [depending_node])
          end
        end
        
        @nodes_by_name = {}
        graph
      end

    end

  end
end
