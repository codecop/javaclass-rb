require File.dirname(__FILE__) + '/setup'
require 'javaclass/dependencies/yaml_serializer'
require 'javaclass/dependencies/edge'
require 'javaclass/dependencies/node'
require 'javaclass/dependencies/graph'

module TestJavaClass
  module TestDependencies
    
    class TestYamlSerializer < Test::Unit::TestCase
    
      def setup
        @serializer = JavaClass::Dependencies::YamlSerializer.new

        node = JavaClass::Dependencies::Node.new('someNode')
        @other = JavaClass::Dependencies::Node.new('otherNode')

        node.add_dependency(JavaClass::Dependencies::Edge.new('from1', 'dependency1'), [@other])
        node.add_dependency(JavaClass::Dependencies::Edge.new('from2', 'dependency1'), [@other])
        node.add_dependency(JavaClass::Dependencies::Edge.new('from3', 'dependency2'), [@other])

        @graph = JavaClass::Dependencies::Graph.new
        @graph.add(node)
        @graph.add(@other)
      end

      def test_has_yaml_eh
        # TODO 'Need to write test_has_yaml_eh'
      end

      def test_graph_to_yaml
        string = @serializer.graph_to_yaml(@graph)
        yaml = YAML.load(StringIO.new(string))

        # we saved a hash with 2 nodes
        assert_equal(2, yaml.size)

        # which one of them was "someNode"
        assert(yaml.has_key?('someNode'))

        # which had 1 dependant node
        dependencies = yaml['someNode']
        assert_equal(1, dependencies.size)

        # with 3 actual imports
        imports = dependencies['otherNode']
        assert_equal(3, imports.size)
        assert_equal('from1->dependency1', imports[0])
      end

      def test_graph_to_yaml_summary
        string = JavaClass::Dependencies::YamlSerializer.new(:outgoing => :summary).graph_to_yaml(@graph)
        yaml = YAML.load(StringIO.new(string))
  
        # we saved a hash with 2 nodes
        assert_equal(2, yaml.size)
  
        # which one of them was "someNode"
        assert(yaml.has_key?('someNode'))
  
        # which had 1 dependant node
        dependencies = yaml['someNode']
        assert_equal(1, dependencies.size)
  
        # with 2 summarized imports
        imports = dependencies['otherNode']
        assert_equal(2, imports.size)
        assert_equal('dependency1', imports[0])
      end

      def test_node_to_yaml
        # fake methods for zentest, tested in all test_graph_to_yaml
        assert(true)
      end

      def test_yaml_to_graph
        string = @serializer.graph_to_yaml(@graph)
        yaml = YAML.load(StringIO.new(string))
        graph = @serializer.yaml_to_graph(yaml)
        
        # we saved a hash with 2 nodes
        assert_equal(2, graph.to_a.size)

        # which one of them was "someNode"
        some_node = graph.to_a.sort[1]
        assert_equal('someNode', some_node.name)

        # which had 1 dependant node
        dependencies = some_node.dependencies
        assert_equal(1, dependencies.size)
        
        new_other = dependencies.keys[0]
        assert_equal(@other, new_other)

        # with 3 actual imports
        imports = dependencies[new_other]
        assert_equal(3, imports.size)
        assert_equal('from2', imports[1].source)
        assert_equal('dependency1', imports[1].target)
      end

    end

  end
end