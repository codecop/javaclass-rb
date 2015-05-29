require 'yaml'
require 'javaclass/dependencies/edge'
require 'javaclass/dependencies/node'
require 'javaclass/dependencies/graph'

module JavaClass
  module Dependencies
    
    # Serializes a Graph of Nodes to YAML.
    # Author::          Peter Kofler
    class YamlSerializer
      
      # Create a serializer with _options_ hash:
      # outgoing:: how to persist outgoing dependencies, either :detailed, :summary or :none 
      def initialize(options = {:outgoing => :detailed })
        @options = options
      end
      
      # Exists a YAML serialized _graph_ ? 
      def has_yaml?(filename)
        File.exist? yaml_file(filename)
      end
      
      # Save the _graph_ to YAML _filename_ .
      def save(filename, graph)
        File.open(yaml_file(filename), 'w') { |f| f.print graph_to_yaml(graph) }
      end

      # Return a String of the YAML serialized _graph_ .
      def graph_to_yaml(graph)
        "---\n" +
        graph.to_a.map { |node| node_to_yaml(node) }.join("\n")
      end

      # Return a String of the YAML serialized _node_ .
      def node_to_yaml(node)
        node.name + ":\n" +
        node.dependencies.keys.map { |dep|
          '  ' + dep.name + dependencies_to_yaml(node.dependencies[dep])
        }.join("\n")
      end

      private

      def yaml_file(filename)
        filename + '.yaml'
      end
            
      def dependencies_to_yaml(dependencies)
        if @options[:outgoing] == :detailed 
          ":\n" + dependencies.map { |dep| "    - #{dep.source}->#{dep.target}" }.join("\n")
        elsif @options[:outgoing] == :summary
          ":\n" + dependencies.map { |dep| dep.target }.uniq.sort.map { |dep| "    - #{dep}" }.join("\n")
        elsif @options[:outgoing] == :none
          ''
        else
          raise "unknown option for outgoing dependencies #{@options[:outgoing]}"
        end
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

      # Load the Graph from YAML _filename_ .
      def load(filename)
        yaml = File.open(yaml_file(filename)) { |f| YAML.load(f) }
        # TODO support compressed yaml files, e.g. inside zip
        yaml_to_graph(yaml)
      end
      
      # Return a Graph from the YAML data _yaml_ .
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
