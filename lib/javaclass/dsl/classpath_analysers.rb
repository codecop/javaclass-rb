require 'javaclass/dsl/loading_classpath'
require 'javaclass/dsl/caching_classpath'
require 'javaclass/analyse/dependencies'
require 'javaclass/analyse/transitive_dependencies'

module JavaClass
  module Dsl

    # A mixin for all class path analyser functions that need to be mixed into LoadingClasspath.
    # Author::          Peter Kofler
    module ClasspathAnalysers
      # add dependency analysis to LoadingClasspath
      include Analyse::Dependencies
      # add transitive dependency analysis to LoadingClasspath
      include Analyse::TransitiveDependencies
    end

    class LoadingClasspath
      include ClasspathAnalysers
    end

    class CachingClasspath
      include ClasspathAnalysers
    end

  end
end
