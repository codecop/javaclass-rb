module JavaClass
  module Classpath

    # A delegator that caches returned classes.
    # Author::          Peter Kofler
    class CachingClasspath

      def initialize(delegatee)
        @delegatee = delegatee
      end

      alias :__old_method_missing :method_missing

      # Send message to +delegatee+
      def method_missing(method_id, *args)
        @delegatee.send(method_id, *args)
      end

    end

  end
end