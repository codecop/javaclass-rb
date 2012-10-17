module JavaClass
  module Dependencies
    
    # An edge in the Graph of dependencies. An edge knows it's source and destination details.
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

      def ==(other)
        @source == other.source && @target == other.target 
      end

      alias eql? ==

      def hash
        [@source, @target].hash
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
