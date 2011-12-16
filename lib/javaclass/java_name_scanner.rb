require 'javaclass/java_name'

module JavaClass

  # TODO Implement hard coded class searching in ClassHeader as well
  # 1) extract common usage classes from here, to be used from 2 places
  # 2) make nice convenience methods here, which get mixed into the DSL, so it's easy
  # 3) add logic to ImportedTypes, which returnes the hardcoded_types, and hardcoded_3rd_party_types
  #    wich scans Java String constants of classes to find Class.Forname
  #    will use the JavaNameScanner module as private inclusion!
  #    ImportedTypes new method all_types = is the old one so calling code stays the same
  #    and a new one is declared_types and hardcoded ,   
  # 4) add 2 methods to Dependencies, so it's also with all hardcoded types possible - automatically, no extra method
  #    will use the JavaNameScanner module as private inclusion!  

  # Mixin with logic to scan for hard coded class names.
  # Author::          Peter Kofler
  module JavaNameScanner

    def scan_config_for_3rd_party_class_names(path)
      scan_config_for_class_names(path).reject { |name| name.in_jdk? }
      # need abstraction for - .reject { |name| name.in_jdk? } - have it three times
      # maybe a mixin for enumerables containing JavaTypes
      #JavaNameEnumerable with - .reject { |name| name.in_jdk? } - und anderen? reject_in_jdk = 3rd Party
      # and find_all { |n| n.same_or_subpackage_of?(x) } -- also very often  = in_package()
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

#      -- Class Scanner
#      init
#        @hardcoded_types = scan_config_for_class_names
#
#      # Determine the imported types of this class and return their names. This does not contain the name if this class itself.
#      def hardcoded_types
#        @hardcoded_types 
#      end
#
#      # Determine the imported types of this class which are not from the JDK. This are all hardcoded_types - all jdk types.
#      def hardcoded_3rd_party_types
#        hardcoded_types.reject { |name| name.in_jdk? }
#      end

#      -- Analyse - add to Dependencies (automatically, no extra method)
#      # Determine all imported types from all classes in this classpath together with count of imports.
#      # An additional block is used as _filter_ on class names.
#      def hardcoded_types(&filter)
#        type_map = Hash.new(0) # class_name (JavaQualifiedName) => cnt
#        hardcoded_3rd_party_types.each do |type|
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

