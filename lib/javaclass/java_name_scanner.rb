require 'javaclass/java_name'

module JavaClass

  # Mixin with logic to scan for hard coded class names.
  # Author::          Peter Kofler
  module JavaNameScanner
  
    # Find all possible class names in all XML and property files under _path_
    def scan_config_for_class_names(path)
      return unless File.exist? path
      if File.file?(path) && path =~ /\.xml$|\.properties$|MANIFEST.MF$/
        scan_text_for_class_names(IO.readlines(path).join)
      else
        Dir.entries(path).reject { |n| n=~/^\./ }.map { |n| scan_config_for_class_names(File.join(path, n)) }.flatten.sort
      end
    end

    TEXT_REGEX = /
      (?:^|>|"|'|=|:)
      \s*
      (   (?:#{JavaLanguage::IDENTIFIER_REGEX}#{JavaLanguage::SEPARATOR_REGEX})+#{JavaLanguage::TYPE_REGEX}   )
      \s*
      (?:$|<|"|')
    /x

    # Extract the list of possible class names from the given _string_ . This will only find
    # names with at least one package name.
    def scan_text_for_class_names(string)
      string.scan(TEXT_REGEX).flatten.map { |match| JavaQualifiedName.new(match) }
    end

    # TODO add method to scan Java String constants of classes to find Class.Forname 
  end

end