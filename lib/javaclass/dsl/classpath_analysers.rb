require 'javaclass/dsl/loading_classpath'
require 'javaclass/analyse/dependencies'
require 'javaclass/analyse/transitive_dependencies'

module JavaClass
  module Dsl

    class LoadingClasspath
      # add dependency analysis to LoadingClasspath
      include Analyse::Dependencies
      # add transitive dependency analysis to LoadingClasspath
      include Analyse::TransitiveDependencies
    end

  end
end
