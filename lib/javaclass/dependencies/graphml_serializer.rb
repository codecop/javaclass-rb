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
      
      # Save the _graph_ to _filename_
      def save(filename, graph)
        File.open(filename + '.graphml', 'w') do |f|
          doc = graph_to_xml(graph)
          doc.write(out_string = '', 2)
          f.print out_string
        end
      end

      # Return an XML document of the GraphML serialitzed _graph_
      def graph_to_xml(graph)
        doc = REXML::Document.new
    
        root = doc.add_element('graphml', 
          'xmlns' => 'http://graphml.graphdrawing.org/xmlns',  
          'xmlns:y' => 'http://www.yworks.com/xml/graphml')
        root.add_element('key', 'id' => 'n1', 'for' => 'node', 'yfiles.type' => 'nodegraphics')
        root.add_element('key', 'id' => 'e1', 'for' => 'edge', 'yfiles.type' => 'edgegraphics')
        
        container = root.add_element('graph', 'edgedefault' => 'directed')
        graph.to_a.each do |node|
          add_node_as_xml(container, node)
        end
    
        doc
      end
      
      # Add the _node_ as XML to the _container_
      def add_node_as_xml(container, node)
        elem = container.add_element('node', 'id' => node.name)
        elem.add_element('data', 'key' => 'n1').
          add_element('y:ShapeNode').
            add_element('y:NodeLabel').
              add_text(node.to_s)
    
        node.dependencies.keys.each do |dep|
          edge = container.add_element('edge')
          edge.add_attribute('id', node.name + '.' + dep.name)
          edge.add_attribute('source', node.name)
          edge.add_attribute('target', dep.name)
          
          number_total_dependencies = node.dependencies[dep].size.to_s
          number_unique_dependencies = node.dependencies[dep].collect { |d| d.target }.uniq.size.to_s
          edge.add_element('data', 'key' => 'e1').
            add_element('y:PolyLineEdge').
              add_element('y:EdgeLabel').
                add_text("#{number_total_dependencies} (#{number_unique_dependencies})")
        end
      end
  
    end

  end
end