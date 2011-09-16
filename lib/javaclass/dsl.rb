require 'javaclass'
require 'javaclass/dsl/java_name_factory'

module JavaClass

  # The module DSL contains shortcuits to make loading and analysing classes
  # easier. This is the high-level API with usage/DSL features.
  # Author::          Peter Kofler
  module Dsl

    # Delegate to JavaClass to create the classpath for _path_ and add option to get all values.
    def classpath(path)
      cp = JavaClass::classpath(path)

      class << cp
        # Load all classes and return the list of them.
        def values
          if !defined?(@values) 
            @values = names.collect { |name| JavaClass::analyse(JavaClass::load_cp(name, self)) }
          end
          @values.dup
        end
        # TODO create a second decorator which adds analyse to all loaded classes
        # then wrap the cache around it and add the @values method in the end
      end

      cp      
    end
    
  end

end

class Object # :nodoc:
  include JavaClass
  include JavaClass::Classpath::Factory
  include JavaClass::Dsl
  include JavaClass::Dsl::JavaNameFactory
end
