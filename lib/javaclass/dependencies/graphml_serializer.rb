require 'rexml/document'

module JavaClass
  module Dependencies

    # Serializes a Graph of Node to GraphML (XML). 
    # To see the graph, use yED, http://www.yworks.com/en/products_yed_about.html to  
    # * load the graphml file. 
    # * Then select all nodes and apply Tools/Fit Node to Label.
    # * Finally apply the Layout/Hierarchical or maybe Layout/Organic/Smart.
    # Author::          Peter Kofler
    class GraphmlSerializer
      include REXML

      # Create a serializer with _options_ hash:
      # edges:: how to chart edge labes, either :no_text or :with_counts 
      def initialize(options = { :edges => :with_counts })
        @options = options
      end

      # Save the _graph_ to _filename_ .
      def save(filename, graph)
        File.open(filename + '.graphml', 'w') do |f|
          doc = graph_to_xml(graph)
          doc.write(out_string = '', 2)
          f.print out_string
        end
      end

      # Return an XML document of the GraphML serialized _graph_ .
      def graph_to_xml(graph)
        doc = create_xml_doc
        container = add_graph_element(doc)
        graph.to_a.each { |node| add_node_as_xml(container, node) }
        doc
      end

      private
      
      def create_xml_doc
        REXML::Document.new
      end
      
      def add_graph_element(doc)
        root = doc.add_element('graphml', 
          'xmlns' => 'http://graphml.graphdrawing.org/xmlns',  
          'xmlns:y' => 'http://www.yworks.com/xml/graphml')
        root.add_element('key', 'id' => 'n1', 'for' => 'node', 'yfiles.type' => 'nodegraphics')
        root.add_element('key', 'id' => 'e1', 'for' => 'edge', 'yfiles.type' => 'edgegraphics')
        
        root.add_element('graph', 'edgedefault' => 'directed')
      end
      
      public
            
      # Add the _node_ as XML to the _container_ .
      def add_node_as_xml(container, node)
        add_node_element(container, node)
    
        node.dependencies.keys.each do |dep|
          add_edge_element(container, node, dep)
        end
      end
  
      private
      
      def add_node_element(container, node)
        elem = container.add_element('node', 'id' => node.name)
        elem.add_element('data', 'key' => 'n1').
          add_element('y:ShapeNode').
            add_element('y:NodeLabel').
              add_text(node.to_s)
      end
  
      def add_edge_element(container, node, dep)
        edge = container.add_element('edge')
        edge.add_attribute('id', node.name + '.' + dep.name)
        edge.add_attribute('source', node.name)
        edge.add_attribute('target', dep.name)
        
        add_edge_label(edge, node.dependencies[dep])
      end
      
      def add_edge_label(edge, dependencies_2_dep)
        if @options[:edges] == :with_counts
          number_total_dependencies = dependencies_2_dep.size.to_s
          number_unique_dependencies = dependencies_2_dep.collect { |d| d.target }.uniq.size.to_s
          edge.add_element('data', 'key' => 'e1').
            add_element('y:PolyLineEdge').
              add_element('y:EdgeLabel').
                add_text("#{number_total_dependencies} (#{number_unique_dependencies})")
        elsif @options[:edges] == :no_text
          # do nothing
        else
          raise "unknown option for edge labels #{@options[:edges]}"
        end
      end

    end
    
  end
end