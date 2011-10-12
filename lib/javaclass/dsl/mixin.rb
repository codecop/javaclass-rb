require 'javaclass/classpath/factory'
require 'javaclass/classscanner/scanners'
require 'javaclass/dsl/loader'
require 'javaclass/dsl/loading_classpath'
require 'javaclass/java_name_scanner'

module JavaClass

  # The module DSL contains shortcuts to make loading and analysing classes
  # easier. This is the high-level API with usage/DSL features.
  # Author::          Peter Kofler
  module Dsl

    class EclipseClasspathDelegator # :nodoc:
      def add_variable(name, value)
        Classpath::EclipseClasspath::add_variable(name, value)
      end
      def skip_lib
        Classpath::EclipseClasspath::skip_lib
      end
    end
    
    # Methods to be mixed into Object.
    # Author::          Peter Kofler
    module Mixin
      # add the Java language constants
      include JavaLanguage
      # add classpath factory methods
      include Classpath::Factory
      # add class header loading
      include Loader
      # decorate classpath with loading
      extend LoadDirective
      wrap_classpath :classpath
      wrap_classpath :environment_classpath
      wrap_classpath :full_classpath
      wrap_classpath :workspace
      # add scanner factory methods
      include ClassScanner::Scanners
      # add hard coded class name finder
      include JavaNameScanner      

      # Delegate shortcut to Classpath::EclipseClasspath
      Eclipse = EclipseClasspathDelegator.new
      
    end

  end
end

class Object # :nodoc:
  include JavaClass::Dsl::Mixin
end
