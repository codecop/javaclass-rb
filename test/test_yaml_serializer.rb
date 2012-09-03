require File.dirname(__FILE__) + '/setup'
require 'javaclass/dependencies/yaml_serializer'
require 'javaclass/dependencies/graph'
require 'javaclass/dependencies/node'

module TestJavaClass
  module TestDependencies
    
    class TestYamlSerializer < Test::Unit::TestCase
    
      def setup
        @serializer = JavaClass::Dependencies::YamlSerializer.new

        node = JavaClass::Dependencies::Node.new('someNode')
        other = JavaClass::Dependencies::Node.new('otherNode')

        node.add_dependency_to('dependency1', [other])
        node.add_dependency_to('dependency2', [other])
        node.add_dependency_to('dependency3', [other])

        @graph = JavaClass::Dependencies::Graph.new
        @graph.add(node)
        @graph.add(other)
      end

      def convert(graph)
        yaml = @serializer.graph_to_yaml(graph)
        YAML.load(StringIO.new(yaml))
      end

      def test_graph_to_yaml_single_node
        # we saved an array with 2 nodes
        nodes = convert(@graph)
        assert_equal(2, nodes.size)

        # which one of them was "someNode"
        data = nodes[0]
        assert(data.has_key?('someNode'))

        # which had 1 dependant node
        dependencies = data['someNode']
        assert_equal(1, dependencies.size)

        # with 3 actual imports
        imports = dependencies['otherNode']
        assert_equal(3, imports.size)
        assert_equal('dependency1', imports[0])
      end

    end

  end
end