require 'javaclass/classscanner/imported_types'

module JavaClass
  
  # The module ClassScanner is for separating namespaces. It contains various
  # decotrators that scan and analyse single class files and provide additional
  # information about the class, e.g. Cyclomatic Complexity.
  # Author::          Peter Kofler
  module ClassScanner
    
    # ClassScanner factory methods to create different kind of scanner decorators.
    # Author::          Peter Kofler
    module Scanners
  
      # Scan parsed _header_ for (selected) _features_ . This ties together all scanners.
      def analyse(header, features=:all)
        # later add feature selection if needed, argument determines delegators, :none, :some, :all
        ImportedTypes.new(
          header
        )
      end

      alias :decorate analyse
      
    end

  end
end
