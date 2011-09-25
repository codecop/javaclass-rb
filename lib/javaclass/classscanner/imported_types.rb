require 'delegate'

module JavaClass
  module ClassScanner

    # Add analysis for imported types to +JavaClassHeader+.
    # Author::          Peter Kofler
    class ImportedTypes < SimpleDelegator

      # Decorate JavaClassHeader _header_ to add imported types lazy scanner.
      def initialize(header)
        super(header)
        @imported_types = nil
      end

      # Determine the imported types of this class and return their names. This does not contain the name if this class itself.
      def imported_types
        @imported_types = @imported_types ||
          references.used_classes.collect { |c| c.to_s.full_name }.sort
        @imported_types
      end

      # Determine the imported types of this class which are not from the JDK. This are all imported_types - all jdk types.
      def imported_3rd_party_types
        imported_types.reject { |name| name.in_jdk? }
      end

    end

  end
end