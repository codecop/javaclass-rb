require 'javaclass'
require 'javaclass/dsl/java_name_factory'

module JavaClass

  # The module DSL contains shortcuits to make loading and analysing classes
  # easier. This ois the high-level API with usage/DSL features.
  # Author::          Peter Kofler
  module Dsl

    # Delegate JavaClass.
    def classpath(path)
      JavaClass::classpath(path)
    end
    
  end

end

class Object # :nodoc:
  include JavaClass
  include JavaClass::Dsl
  include JavaClass::Dsl::JavaNameFactory
end
