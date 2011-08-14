module JavaClass
  module Classpath

    # A delegator that caches returned class files.
    # Author::          Peter Kofler
    class CachingClasspath

      def initialize(delegatee)
        @delegatee = delegatee
        @cache = {}
      end

      # Ask the cache for the _classname_ and return it. Else delegate loading to +delegatee+ .
      def load_binary(classname)
        key = classname.to_javaname.full_name
        if !@cache.include?(key)
          @cache[key] = @delegatee.load_binary(classname)
        end
        @cache[key]
      end

      alias :__old_method_missing :method_missing

      # Delegate all other messages to +delegatee+ . This might not work for methods defined in +Object+ because they are
      # overwritten here.
      def method_missing(method_id, *args)
        @delegatee.send(method_id, *args)
      end

    end

  end
end