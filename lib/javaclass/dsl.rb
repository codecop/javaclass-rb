require 'javaclass'
require 'javaclass/dsl/java_name_factory'

module JavaClass

  # The module DSL contains shortcuits to make loading and analysing classes
  # easier. This ois the high-level API with usage/DSL features.
  # Author::          Peter Kofler
  module Dsl

    # Delegate to JavaClass to create the classpath for _path_ and add option to get all values.
    def classpath(path)
      cp = JavaClass::classpath(path)

      class << cp
        # Load all classes and return the list of them.
        def values
          if defined?(@values) && @values
            @values
          else
            @values = names.collect { |name| JavaClass::analyse(JavaClass::load_cp(name, self)) }.dup
          end
        end
      end

      cp      
    end
    
  end

end

class Object # :nodoc:
  include JavaClass
  include JavaClass::Dsl
  include JavaClass::Dsl::JavaNameFactory
end
