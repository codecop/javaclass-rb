require 'javaclass/java_name'

module JavaClass

  # Mixin with logic to scan for hard coded class names.
  # Author::          Peter Kofler
  module JavaNameScanner

    def scan_config_for_3rd_party_class_names(path)
      scan_config_for_class_names(path).reject { |c| c.in_jdk? }
    end

    # Find all possible class names in all XML and property files under _path_
    def scan_config_for_class_names(path)
      return unless File.exist? path
      if File.file?(path) 
        if path =~ /\.xml$|\.properties$|MANIFEST.MF$/
          scan_text_for_class_names(IO.readlines(path).join)
        else
          []
        end
      else
        Dir.entries(path).reject { |n| n=~/^\./ }.map { |n| scan_config_for_class_names(File.join(path, n)) }.flatten.sort
      end
    end

    TEXT_REGEX = /
      (?:^|>|"|'|=|:)
      \s*
      (   (?:#{JavaLanguage::IDENTIFIER_REGEX}#{JavaLanguage::SEPARATOR_REGEX})+#{JavaLanguage::TYPE_REGEX}   )
      \s*
      (?:$|<|"|'|:)
    /x

    # Extract the list of possible class names from the given _string_ . This will only find
    # names with at least one package name.
    def scan_text_for_class_names(string)
      string.scan(TEXT_REGEX).flatten.map { |match| JavaQualifiedName.new(match) }
    end

  end

  # TODO make class and add logic like in ImportedTypes
  # e.g. hardcoded_types, 3rd_party_types

  # init
  #        @hardcoded_types = scan_config_for_class_names

#      # Determine the imported types of this class and return their names. This does not contain the name if this class itself.
#      def hardcoded_types
#        @hardcoded_types 
#      end
#
#      # Determine the imported types of this class which are not from the JDK. This are all hardcoded_types - all jdk types.
#      def hardcoded_3rd_party_types
#        hardcoded_types.reject { |name| name.in_jdk? }
#      end

#      # Determine all imported types from all classes in this classpath together with count of imports.
#      # An additional block is used as _filter_ on class names.
#      def hardcoded_types(&filter)
#        type_map = Hash.new(0) # class_name (JavaQualifiedName) => cnt
#        hardcoded_3rd_party_types.each do |type|
#
#          # hash keys need to be frozen to keep state
#          if !type_map.include?(type)
#            type = type.freeze 
#          end
#
#          type_map[type] += 1
#        end
#        type_map
#      end
#
#      # Determine all hardcoded types from all classes in this classpath.
#      # An additional block is used as _filter_ on class names.
#      def external_types(&filter)
#        used_types(&filter).keys.sort
#      end

end

# TODO add method to scan Java String constants of classes to find Class.Forname 
