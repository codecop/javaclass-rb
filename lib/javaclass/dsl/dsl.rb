require 'javaclass/classpath/factory'
require 'javaclass/classscanner/scanners'
require 'javaclass/dsl/loader'
require 'javaclass/dsl/java_name_factory'
require 'javaclass/dsl/loading_classpath'

module JavaClass

  # The module DSL contains shortcuits to make loading and analysing classes
  # easier. This is the high-level API with usage/DSL features.
  # Author::          Peter Kofler
  module Dsl

    # Methods to be mixed into Object.
    # Author::          Peter Kofler
    module ObjectMethods
      # add classpath factory methods
      include Classpath::Factory
      # add class header loading
      include Loader
      # decorate classpath with loading
      extend JavaClass::Dsl::LoadDirective
      wrap_classpath :classpath
      wrap_classpath :environment_classpath
      wrap_classpath :full_classpath
      wrap_classpath :workspace
      # add scanner factory methods
      include ClassScanner::Scanners
      # support native Java classnames
      include JavaNameFactory

    end

  end
end

class Object # :nodoc:
  include JavaClass::Dsl::ObjectMethods
end
