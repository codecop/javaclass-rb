module JavaClass
  module Dependencies
    
    # A node in a graph of dependencies. A node contains a map of dependencies to other nodes.
    # Author::          Peter Kofler
    class Node

      attr_reader :name
      attr_reader :dependencies
    
      def initialize(name)
        @name = name
        @dependencies = Hash.new([])
      end

      def to_s
        @name
      end

      # Add a list of _provider_ Node for a _dependency_ 
      def add_dependency_for(dependency, providers)
        if providers.size == 0
          # external dependency, skip this
        elsif providers.size == 1
          # add dependency to this provider
          provider = providers[0]
          @dependencies[provider] = @dependencies[provider] + [dependency]
        else
          warn "dependency to #{dependency} found more than once: #{providers.join(', ')}"
        end
      end
      
    end

  end
end
