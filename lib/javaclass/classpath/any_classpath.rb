require 'javaclass/classpath/composite_classpath'

module JavaClass
  module Classpath

    # Classpath containing everything under a folder. This is for an unstructured collection of JARs and class files.
    # Author::   Peter Kofler
    class AnyClasspath < CompositeClasspath

      # Create a classpath with all classes found under this _folder_ wherever they are.
      def initialize(folder)
        super(File.join(folder, '*'))
        find_jars(folder)
        add_file_name(folder)
      end
    end

  end
end
