require 'javaclass/dsl/java_name_factory'

module JavaClass

  # The module Dsl contains shortcuits to make loading and analysing classes
  # easier. This ois the high-level API with usage/DSL features.
  # Author::          Peter Kofler
  module Dsl

  end

end

class Object # :nodoc:
  include JavaClass::Dsl::JavaNameFactory
end
