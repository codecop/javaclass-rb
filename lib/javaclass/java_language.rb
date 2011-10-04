module JavaClass

  # All kind of constant information related to Java and the Java language.
  # Author::   Peter Kofler
  module JavaLanguage

    SOURCE = '.java'
    CLASS = '.class'
    CLASS_REGEX = /#{Regexp.escape(CLASS)}$/

    # A general Java identifier.
    IDENTIFIER_REGEX = /[a-zA-Z_\$][a-zA-Z_\$0-9]*/
    
    # A proper type (class) name.
    TYPE_REGEX = /^[A-Z][a-zA-Z0-9_\$]*$/

    # A proper member (field or method) name.
    MEMBER_REGEX = /^[a-z][a-zA-Z0-9_\$]*$/

    RESOURCE_FOLDER = File.join(File.dirname(__FILE__), 'resources')

    # Reserved words of the Java language.
    RESERVED_WORDS = IO.readlines(File.join(RESOURCE_FOLDER, 'reserved_words.txt')).map { |l| l.chomp }

    # List of ISO 3166 two letter country names. Used to recognize valid domain suffix/Java package names.
    # See::            http://www.iso.org/iso/list-en1-semic-3.txt
    ISO_COUNTRIES = IO.readlines(File.join(RESOURCE_FOLDER, 'iso_3166_countries.txt')).map { |l| l.chomp }

    # List of non  ISO 3166 U.S. domain suffix.
    US_DOMAINS = %w| com net biz org |

    # List of all (usual) allowed Java package prefixes.
    ALLOWED_PACKAGE_PREFIX = %w| java javax | + US_DOMAINS + ISO_COUNTRIES

    # List of all package prefixes found in the JDK (up to 1.6).
    JDK_PACKAGES = IO.readlines(File.join(RESOURCE_FOLDER, 'jdk_packages.txt')).map { |l| l.chomp }
    JDK_PACKAGES_REGEX = JDK_PACKAGES.collect { |pkg| /^#{pkg}\./ }

  end

end
