require 'delegate'
require 'javaclass/classfile/java_class_header'

module JavaClass

  module ClassScanner

    # Add analysis for imported types to +JavaClassHeader+.
    # Author::          Peter Kofler
    class ImportedTypes < DelegateClass(JavaClass::ClassFile::JavaClassHeader)

      # Decorate JavaClassHeader _header_ .
      def initialize(header)
        super(header)
        @imported_types = nil
      end

      # Determine the imported types of this class and return their names.
      def imported_types
        @imported_types = @imported_types ||
          references.used_classes.collect { |c| c.to_s.full_name }.sort
        @imported_types
      end

      # Determine the imported types of this class which are not from the JDK.
      def imported_3rd_party_types
        imported_types.reject { |name| name.in_jdk? }
      end
      # TODO bug: [Ljava.lang.Class; -> does not work with arrays
      
    end

  end
end