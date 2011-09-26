require 'delegate'
require 'javaclass/classpath/composite_classpath'

module JavaClass
  module Classpath

    # A delegator classpath that tracks which classes have been accessed.
    # Author::          Peter Kofler
    class TrackingClasspath < SimpleDelegator

      # Create a tracked instance of the _classpath_ .
      def initialize(classpath)
        unless classpath.respond_to?(:load_binary) || classpath.respond_to?(:load)  
          raise "wrong type of delegatee #{classpath.class}"
        end
        @classpath = classpath
        reset_access
        super(classpath)
      end

      # Reset all prior marked access.
      def reset_access
        @accessed = {}
      end
      
      # Load the binary and mark the _classname_ as accessed.
      def load_binary(classname)
        mark_accessed(classname)
        @classpath.load_binary(classname)
      end

      # Read and disassemble the given class _classname_ and mark as accessed.
      def load(classname)
        mark_accessed(classname)
        @classpath.load(classname)
      end
      
      # Mark the _classname_ as accessed. Return the number of accesses so far.
      def mark_accessed(classname)
        key = classname.to_javaname.full_name
        @accessed[key] = (@accessed[key] || 0) + 1
      end
      
      # Was the _classname_ accessed then return the count? If _classname_ is nil then check if any class was accessed.
      def accessed?(classname=nil)
        if classname
          @accessed[classname.to_javaname.full_name] 
        else
          total = @accessed.values.inject(0) {|s,e| s + e }
          if total > 0 then total else nil end
        end
      end

      # Return the classnames of all accessed classes.      
      def all_accessed
        @accessed.keys.sort
      end
      
    end

    class CompositeClasspath 

      alias __old__add_file_name__ add_file_name # :nodoc:
      
      # Add the _name_ class path which may be a file or a folder to this classpath.
      def add_file_name(name)
        if FolderClasspath.valid_location?(name)
          add_element(TrackingClasspath.new(FolderClasspath.new(name)))
        elsif JarClasspath.valid_location?(name)
          add_element(TrackingClasspath.new(JarClasspath.new(name)))
        else
          # warn("tried to add invalid classpath location #{name}")
        end
      end
      
      # Mark the _classname_ as accessed. Return the number of accesses so far.
      def mark_accessed(classname)
        found = @elements.find { |e| e.includes?(classname) }
        if found then found.mark_accessed(classname) else nil end
      end
      
      # Reset all prior marked access in child elements.
      def reset_access
        @elements.each { |e| e.reset_access }
      end

      # Return the classnames of all accessed classes in child elements.    
      def all_accessed
        @elements.map { |cp| cp.all_accessed }.flatten.uniq.sort
      end

    end
    
  end
end
