module JavaClass
  module Dependencies
    
    # An edge in the graph of dependencies. An enge knows it's originatargetr and destination details.
    # Author::          Peter Kofler
    class Edge

      attr_reader :source
      attr_reader :target
      
      def initialize(source, target)
        @source = source
        @target = target
      end

      def to_s
        "#{@target} (#{@source})"
      end
      
      def <=>(other)
        res = @target <=> other.target
        if res == 0
          res = @source <=> other.source
        end
        res 
      end

    end

  end
end
