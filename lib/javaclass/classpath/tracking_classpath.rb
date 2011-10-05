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

      # Must return the wrapped classpath elements of this decorated classpath.
      def elements
        if [FolderClasspath, JarClasspath].include?(@classpath.class)
          [self]
        else
          @classpath.elements
        end
      end
      
      # Reset all prior marked access.
      def reset_access
        @accessed = Hash.new(0)
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
        @accessed[key] += 1
      end
      
      # Was the _classname_ accessed then return the count? If _classname_ is nil then check if any class was accessed.
      def accessed?(classname=nil)
        if classname
          total = @accessed[classname.to_javaname.full_name] 
        else
          total = @accessed.values.inject(0) {|s,e| s + e }
        end
        if total > 0 then total else nil end
      end

      # Return the classnames of all accessed classes.      
      def all_accessed
        @accessed.keys.sort
      end
      
    end

    class CompositeClasspath 

      alias __old__add_element__ add_element # :nodoc:
      
      # Wrap the _elem_ classpath with TrackingClasspath and add it to the list.
      def add_element(elem)
        __old__add_element__(TrackingClasspath.new(elem)) unless @elements.find { |cpe| cpe == elem }
      end

      # Reset all prior marked access in child elements.
      def reset_access
        @elements.each { |e| e.reset_access }
      end
            
      # Mark the _classname_ as accessed. Return the number of accesses so far.
      def mark_accessed(classname)
        key = classname.to_javaname.to_classname
        found = @elements.find { |e| e.includes?(key) }
        if found then found.mark_accessed(key) else nil end
      end

      # Was the _classname_ accessed then return the count? If _classname_ is nil then check if any class was accessed.
      def accessed?(classname=nil)
        if classname
          key = classname.to_javaname.to_classname
          found = @elements.find { |e| e.includes?(key) }
          if found then found.accessed?(key) else nil end 
        else
          total = @elements.inject(0) do |s,e| 
            accessed = e.accessed?
            if accessed then s + accessed else s end
          end
          if total > 0 then total else nil end
        end
      end

      # Return the classnames of all accessed classes in child elements.    
      def all_accessed
        @elements.map { |cp| cp.all_accessed }.flatten.sort
      end

    end
    
  end
end
