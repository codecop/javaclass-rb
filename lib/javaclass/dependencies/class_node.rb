require 'javaclass/dependencies/node'
require 'javaclass/dependencies/edge'

module JavaClass
  module Dependencies
    
    # A concrete Node which contains a ClassFile and its dependencies.
    # This models a Node as a Java class.
    # Author::          Peter Kofler
    class ClassNode < Node
    
      def initialize(name, java_class)
        super(name)
        @java_class = java_class
      end

      # Iterate on a list of Edge dependencies this node has.
      def outgoing_dependencies
        @java_class.imported_3rd_party_types.each do |import|
            yield Edge.new(@java_class.this_class, import)
        end
      end
      
      # Does this Node satisfy the dependency. 
      def satisfies?(class_name)
        @java_class.this_class == class_name
      end

    end
    # TODO add tests

  end
end