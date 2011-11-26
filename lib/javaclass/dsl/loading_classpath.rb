require 'delegate'
require 'javaclass/classscanner/scanners'
require 'javaclass/dsl/loader'

module JavaClass
  module Dsl

    # A delegator Classpath that loads and parses classes.
    # Author::          Peter Kofler
    class LoadingClasspath < SimpleDelegator
      
      # Create a lading instance of the _classpath_ .
      def initialize(classpath)
        unless classpath.respond_to? :load_binary 
          raise ArgumentError, "wrong type of delegatee #{classpath.class}"
        end
        super(classpath)
      end

      # Read and disassemble the given class _classname_ .
      def load(classname)
        analyse(load_cp(classname, self))
      end

      # Load _listed_ or all classes and return the list of them. An additional block is used as _filter_ on class names.
      def values(listed=nil, &filter)
        listed ||= names(&filter)
        listed.collect { |name| load(name) }
      end
      
      private

      # add loader so binary data from classpath can be parsed
      include Loader
      # add scanners so loaded class headers can be scanned
      include ClassScanner::Scanners
      
    end

    # A special directive which wraps a method with a LoadingClasspath.
    # Author::          Peter Kofler
    module LoadDirective # :nodoc:
      
      # Wrap the method with _method_name_ in a LoadingClasspath.
      def wrap_classpath(method_name)
        self.module_eval("alias :__pure_#{method_name}__ #{method_name.to_s}")
        self.module_eval("def #{method_name}(*obj) LoadingClasspath.new(__pure_#{method_name}__(*obj)) end")
      end
      
    end      
    
  end
end
