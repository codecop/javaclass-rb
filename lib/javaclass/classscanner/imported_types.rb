require 'delegate'
require 'javaclass/classfile/java_class_header'

module JavaClass

  # The module ClassScanner is for separating namespaces. It contains various
  # decotrators that scan and analyse single class files and provide additional
  # information about the class, e.g. Cyclomatic Complexity.
  # Author::          Peter Kofler
  module ClassScanner

    # TODO implement from Analysis
    # Author::          Peter Kofler
    class ImportedTypes < DelegateClass(JavaClass::ClassFile::JavaClassHeader)

      # Decorate JavaClassHeader _header_ .
      def initialize(header)
        super(header)
      end

      # Determine the imported types of this class.
      def imported_types
        references.used_classes.collect { |c| c.full_name }.reject { |name| in_jdk?(name) }
      end

    end
    # TODO add test
    # TODO create top level file which binds together all decorators.
    # have an argument to determine delegators, :none, :some, :all
    
  end
end