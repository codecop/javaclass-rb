module JavaClass
  module Dependencies
    
    # A node in a Graph of dependencies. A node contains a map of dependencies (Edge) to other nodes.
    # Author::          Peter Kofler
    class Node

      attr_reader :name
      attr_reader :size
      attr_reader :dependencies
    
      def initialize(name, size=0)
        @name = name
        @size = size
        @dependencies = Hash.new([])
      end

      def to_s
        if @size > 0
          "#{@name} (#{@size.to_s})"
        else
          @name
        end
      end
      
      def ==(other)
        other.respond_to?(:name) && @name == other.name
      end
      
      def hash
        @name.hash
      end
      
      def <=>(other)
        @name <=> other.name 
      end

      # Add a _dependency_ Edge for a list of _provider_ Node if the dependency is not included already. 
      def add_dependency(dependency, providers)
        if providers.size == 0
          # external dependency, skip this
        elsif providers.size == 1
          # add dependency to this provider
          provider = providers[0]
          # unless @dependencies[provider].include? dependency
          @dependencies[provider] = @dependencies[provider] + [dependency]
          # end
        else
          warn "dependency to \"#{dependency}\" found more than once: #{providers.join(', ')}"
        end
      end

      # Add a list _dependencies_ of _provider_ . 
      def add_dependencies(dependencies, providers)
        dependencies.each do |dependency|
          add_dependency(dependency, providers)
        end
      end

    end

  end
end
