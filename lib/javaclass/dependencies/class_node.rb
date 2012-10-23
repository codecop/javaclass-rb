require 'javaclass/dependencies/node'
require 'javaclass/dependencies/edge'

module JavaClass
  module Dependencies
    
    # A concrete Node which contains a ClassFile and its dependencies.
    # This models a Node as a Java class.
    # Author::          Peter Kofler
    class ClassNode < Node
    
      def initialize(java_class)
        super(java_class.to_classname)
        @java_class = java_class
      end

      # Iterate on a list of Edge dependencies this node has.
      def outgoing_dependencies
        @java_class.imported_3rd_party_types.each do |import|
            yield Edge.new(@java_class.to_classname, import.to_classname)
        end
        # later iterate all types/fields/methods and create an edge from the method to the target type.
        # So Edges make sense and multiplicity in dependencies is possible. 
      end
      
      # Does this Node satisfy the dependency to _class_name_ ?
      def satisfies?(class_name)
        @java_class.to_classname == class_name.to_classname
        # later class name will be a full qualified class#method or field name.
      end

    end
    # TODO add tests

  end
end