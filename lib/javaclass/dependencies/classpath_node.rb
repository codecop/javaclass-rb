require 'javaclass/dependencies/node'

module JavaClass
  module Dependencies
    
    # A concrete Node which contains a Classpath and its dependencies.
    # Author::          Peter Kofler
    class ClasspathNode < Node
    
      def initialize(name, data)
        super(name)
        @data = data
      end

      # Return a list of String names of the dependencies this node has.
      def dependency_names
        @data.external_types
      end
      
      # Does this Node satisfy the dependency.
      def satisfies?(dependency_name)
        @data.includes?(dependency_name)
      end

    end

  end
end