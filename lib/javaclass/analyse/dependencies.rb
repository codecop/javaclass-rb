module JavaClass

  # The module Analyse is for separating namespaces. It contains various methods
  # to analyse classes accross a whole whole code bases (Classpath).
  # Author::          Peter Kofler
  module Analyse

    # Class dependency analysing to be mixed into a Classpath.
    # Author::          Peter Kofler
    module Dependencies

      # Return all types in this classpath. An additional block is used as _filter_ on class names.
      def types(&filter)
        names(&filter).collect { |c| c.full_name }.sort
      end

      # Determine all imported types from all classes in this classpath together with count of imports.
      # An additional block is used as _filter_ on class names.
      def used_types(&filter)
        type_map = Hash.new(0)
        values(&filter).collect { |clazz| clazz.imported_3rd_party_types }.flatten.each do |type|
          type_map[type] += 1
        end
        type_map
      end

      # Determine all foreign imported types from all classes in this classpath.
      # An additional block is used as _filter_ on class names.
      def external_types(&filter)
        used_types(&filter).keys.sort - types(&filter)
      end

    end

  end
end