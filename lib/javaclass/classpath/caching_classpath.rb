require 'delegate'

module JavaClass
  module Classpath

    # A delegator classpath that caches returned class files in a map by full qualified class names.
    # Author::          Peter Kofler
    class CachingClasspath < SimpleDelegator

      # Create a cached instance of the _classpath_ .
      def initialize(classpath)
        unless classpath.respond_to? :load_binary 
          raise "wrong type of delegatee #{classpath.class}"
        end
        @classpath = classpath
        @cache = {}
        super(classpath)
      end

      # Ask the cache for the _classname_ and return it. Else delegate loading.
      def load_binary(classname)
        key = classname.to_javaname.full_name
        if !@cache.include?(key)
          @cache[key] = @classpath.load_binary(classname)
        end
        @cache[key]
      end

      # alias :__old_method_missing :method_missing

      # # Delegate all other messages. This might not work for methods defined
      # # in +Object+ because they are overwritten in this delegator.
      # def method_missing(method_id, *args)
      #    @classpath.send(method_id, *args)
      # end

    end

  end
end
