require 'javaclass'
require 'javaclass/classpath/factory'
require 'javaclass/classscanner/scanners'
require 'javaclass/dsl/java_name_factory'

module JavaClass

  # The module DSL contains shortcuits to make loading and analysing classes
  # easier. This is the high-level API with usage/DSL features.
  # Author::          Peter Kofler
  module Dsl
    include Classpath::Factory
    include ClassScanner::Scanners
    include JavaNameFactory

    alias :__pure_classpath classpath
    
    # Delegate to JavaClass to create the classpath for _path_ and add option to get all values.
    def classpath(path)
      cp = __pure_classpath(path)

      class << cp
        # Load all classes and return the list of them.
        def values
          @values ||= names.collect { |name| analyse(JavaClass::load_cp(name, self)) }
        end
        # TODO CONTINUE 8 - finish first version of DSL, mix in JavaClass somehow
        # create a second decorator which adds analyse to all loaded classes
        # then wrap the cache around it and add the @values method in the end
      end

      cp      
    end
    # TODO 10 delegate all methods from the factory and wrap it in a new cp decorator 
    # that supports values
    # 1st create a decorator that supports values method
    # 2nd create an attribute like "alias" that applies the wrapper to the method
    # (does the alias and creates delegate), see Delegate Ruby code
    # 3rd put new attribite here for the methods of factory
    
    
  end

end

class Object # :nodoc:
  include JavaClass::Dsl
end
