require 'javaclass/dependencies/node'

module JavaClass
  module Dependencies
    
    # A concrete Node which contains a Classpath and its dependencies.
    # Author::          Peter Kofler
    class ClasspathNode < Node
    
      def initialize(name, classpath)
        super(name, classpath.count)
        @classpath = classpath
      end

      # Return a list of String names of the dependencies this node has.
      def dependency_names
        @classpath.external_types
      end
      
      # Does this Node satisfy the dependency.
      def satisfies?(dependency_name)
        @classpath.includes?(dependency_name)
      end

    end

  end
end