require 'javaclass/dependencies/node'
require 'javaclass/dependencies/edge'

module JavaClass
  module Dependencies
    
    # A concrete Node which contains a Classpath and its dependencies.
    # This models a Node as a component, maybe an Eclipse plugin, a Maven module or a library. 
    # Dependencies (Edge) contain all references imported by any class of this component.  
    # Author::          Peter Kofler
    class ClasspathNode < Node
    
      def initialize(name, classpath)
        super(name, classpath.count)
        @classpath = classpath
      end

      # Iterate on a list of Edge dependencies this node has.
      def outgoing_dependencies
        @classpath.values.each do |clazz|
          clazz.imported_3rd_party_types.each do |import|
            unless satisfies?(import) 
              yield Edge.new(clazz.to_classname, import)
            end
          end
        end
      end
      
      # Does this Node satisfy the dependency.
      def satisfies?(dependency_name)
        @classpath.includes?(dependency_name)
      end

    end

  end
end