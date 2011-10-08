require 'delegate'

module JavaClass
  module Dsl

    # A delegator classpath that caches loaded class files in a map by full qualified class names.
    # Author::          Peter Kofler
    class CachingClasspath < SimpleDelegator

      # Create a cached instance of the _classpath_ .
      def initialize(classpath)
        unless classpath.respond_to? :load 
          raise ArgumentError, "wrong type of delegatee #{classpath.class}"
        end
        @classpath = classpath
        @cache = {}
        super(classpath)
      end

      # Ask the cache for the _classname_ and return it. Else delegate loading.
      def load(classname)
        key = classname.to_javaname.full_name
        if !@cache.include?(key)
          @cache[key] = @classpath.load(classname)
        end
        @cache[key]
      end

      # Load _listed_ or all classes. Duplicate method to use the cache of decorator.
      def values(listed=nil, &filter)
        listed ||= names(&filter)
        listed.collect { |name| load(name) }
      end
      
    end

  end
end
