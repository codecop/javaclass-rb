require 'javaclass/classpath/composite_classpath'

module JavaClass
  module Classpath

    # Classpath containing everything under a folder. This is for an unstructured collection of JARs and class files.
    # Author::   Peter Kofler
    class AnyClasspath < CompositeClasspath

      # Return the list of classnames found under this _folder_ wherever they are.
      def initialize(folder)
        super()
        find_jars(folder)
        add_file_name(folder)
      end
    end

  end
end
