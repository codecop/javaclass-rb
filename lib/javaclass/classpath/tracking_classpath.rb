require 'delegate'

module JavaClass
  module Classpath

    # A delegator classpath that tracks which classes have been accessed.
    # Author::          Peter Kofler
    class TrackingClasspath < SimpleDelegator

      # Create a tracked instance of the _classpath_ .
      def initialize(classpath)
        unless classpath.respond_to? :load_binary 
          raise "wrong type of delegatee #{classpath.class}"
        end
        @classpath = classpath
        @accessed = Hash.new(0)
        super(classpath)
      end

      # Load the binary and mark the _classname_ as accessed.
      def load_binary(classname)
        mark_accessed(classname)
        @classpath.load_binary(classname)
      end

      # Mark the _classname_ as accessed.
      def mark_accessed(classname)
        key = classname.to_javaname.full_name
        @accessed[key] = @accessed[key] + 1
      end
      
      # Was the _classname_ accessed? If _classname_ is nil then check if any class was accessed.
      def accessed?(classname=nil)
        if classname
          @accessed[classname.to_javaname.full_name] != 0
        else
          !@accessed.empty?
        end
      end
      
    end

  end
end
