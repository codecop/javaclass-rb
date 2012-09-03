module JavaClass
  module Dependencies

    # Serializes a Graph of Nodes to YAML.
    # Author::          Peter Kofler
    class YamlSerializer
    
      # Save the _graph_ to _filename_
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
        '- ' + node.name + ":\n" +
        node.dependencies.keys.map { |dep| 
          '    ' + dep.name + ": ---\n" + dependencies_to_yaml(node.dependencies[dep]) 
        }.join("\n")
      end
      
      def dependencies_to_yaml(dependencies)
        dependencies.map { |dep| '      - ' + dep.to_s }.join("\n")
      end

    end

  end
end