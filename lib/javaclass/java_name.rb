require 'javaclass/java_language'
require 'javaclass/delegate_directive'

module JavaClass

  # Mixin with logic to work with Java package names. The "mixer" needs to declare a String field @package.
  # Author::          Peter Kofler
  module PackageLogic
    SEPARATOR = '.'
    SEPARATOR_REGEX = Regexp.escape(SEPARATOR)

    # Return the package name of a classname or the name of the package. Return an empty String if default package.
    # This returns just the plain String.
    def package
      @package
    end

    # Return +true+ if this class is in same or in a subpackage of the given Java _packages_ or
    # if this package is same or a subpackage (with .).
    def same_or_subpackage_of?(packages)
      packages.find {|pkg| @package == pkg } != nil || subpackage_of?(packages)
    end

    # Return +true+ if this class is in a subpackage of the given Java _packages_ .
    def subpackage_of?(packages)
      packages.find {|pkg| @package =~ /^#{Regexp.escape(pkg)}#{SEPARATOR_REGEX}/ } != nil
    end

    # Is this package or class in the JDK? Return the first JDK package this is inside or nil.
    def in_jdk?
      if @package && @package != ''
        package_dot = @package + '.'
        JavaLanguage::JDK_PACKAGES_REGEX.find { |package| package_dot =~ package }
      else
        # default package is never in JDK
        false
      end
    end

    private

    def package_remove_trailing_dot!
      @package = @package[0..-2] if @package.size > 0 && @package[-1..-1] == SEPARATOR
    end

  end

  # Mixin with logic to work with Java simple names. The "mixer" needs to declare a String field @simple_name.
  # Author::          Peter Kofler
  module SimpleNameLogic

    # Return the simple name of this class or package.
    # This returns just the plain String.
    def simple_name
      @simple_name
    end

    # Split the simple name at the camel case boundary _pos_ and return two parts. _pos_ may be < 0 for counting backwards.
    def split_simple_name(pos)
      parts = @simple_name.scan(/([A-Z][^A-Z]+)/).flatten
      pos = parts.size + pos +1 if pos < 0
      return ['', @simple_name] if pos <= 0
      return [@simple_name, ''] if pos >= parts.size
      [parts[0...pos].join, parts[pos..-1].join]
    end

  end

  # TODO comment
  class JavaPackageName < String
    include PackageLogic

    SEPARATOR = '.'
    SEPARATOR_REGEX = Regexp::escape(SEPARATOR)
    VALID_REGEX = /^
                    (?:   #{JavaLanguage::IDENTIFIER_REGEX}#{SEPARATOR_REGEX}   )*
                    #{JavaLanguage::LOWER_IDENTIFIER_REGEX}#{SEPARATOR_REGEX}?
                   $/x

    def self.valid?(string)
      string =~ VALID_REGEX
    end

    def initialize(string)
      super string
      if string =~ VALID_REGEX
        @package = string
      else
        raise ArgumentError, "#{string} is no valid qualified package name"
      end
      package_remove_trailing_dot!
    end

    def to_javaname
      self
    end

  end

  # A full qualified class name. That is <code>a.b.C</code>.
  # Author::          Peter Kofler
  class JavaQualifiedName < String
    include PackageLogic
    include SimpleNameLogic

    SEPARATOR = '.'
    SEPARATOR_REGEX = Regexp::escape(SEPARATOR)
    VALID_REGEX = /^
                    (
                      (?:  #{JavaLanguage::IDENTIFIER_REGEX}#{SEPARATOR_REGEX}   )*
                    )
                    (
                      #{JavaLanguage::IDENTIFIER_REGEX}
                    )
                   $/x

    def self.valid?(string)
      string =~ VALID_REGEX
    end

    def initialize(string)
      super string
      if string =~ VALID_REGEX
        @package = $1 || ''
        @simple_name = $2
        @full_name = string
      else
        raise ArgumentError, "#{string} is no valid qualified name"
      end
      package_remove_trailing_dot!
    end

    # Full normalized class name of this class. This returns just the plain String.
    def full_name
      @full_name
    end

    def to_javaname
      self
    end

    # Return the full classname of this class, e.g. <code>java.lang.Object</code>.
    def to_classname
      self
    end

    # Return the VM name of this class, e.g. <code>java/lang/Object</code>.
    def to_jvmname
      JavaVMName.new(@full_name.gsub(SEPARATOR, JavaVMName::SEPARATOR), self) # TODO lazy field
    end

    # Return the Java source file name of this class, e.g. <code>java/lang/Object.java</code>.
    def to_java_file
      to_jvmname + JavaLanguage::SOURCE # TODO lazy field
    end

    # Return the Java class file name of this class, e.g. <code>java/lang/Object.class</code>.
    def to_class_file
      # p self, self.class, @package, @simple_name, @full_name
      JavaClassFileName.new(@full_name.gsub(SEPARATOR, JavaClassFileName::SEPARATOR) + JavaLanguage::CLASS, self)
      # TODO lazy field
    end

  end

  # TODO implement for inner classes: CollectionUtils$IChecker

  # Special String with methods to work with Java class or package names.
  # Author::          Peter Kofler

  # Delegation of JavaQualifiedName's methods. The "mixer" needs to define a to_classname method which returns a JavaQualifiedName.
  # Author::          Peter Kofler
  module JavaQualifiedNameDelegation # :nodoc:
    extend DelegateDirective

    def to_javaname
      self
    end

    # TODO remove these 3, implement them in all 3 cases, as they are similar (all with /)
    delegate :to_jvmname, :to_classname
    delegate :to_java_file, :to_classname
    delegate :to_class_file, :to_classname

    delegate :package, :to_classname
    delegate :simple_name, :to_classname
    delegate :full_name, :to_classname
    delegate :same_or_subpackage_of?, :to_classname
    delegate :subpackage_of?, :to_classname
    delegate :split_simple_name, :to_classname
    delegate :in_jdk?, :to_classname
  end

  # A class name from the JVM. That is <code>a/b/C</code>. These names are read from the constant pool.
  # Atoms and arrays are expressed as JVM names as well.
  # Author::          Peter Kofler
  class JavaVMName < String
    include JavaQualifiedNameDelegation

    SEPARATOR = '/'
    SEPARATOR_REGEX = Regexp::escape(SEPARATOR)
    ARRAY_REGEX = /^\[+L(.+);$|^\[+([A-Z])$/
    VALID_REGEX = /^
                    (?:   #{JavaLanguage::IDENTIFIER_REGEX}#{SEPARATOR_REGEX}   )*
                    #{JavaLanguage::IDENTIFIER_REGEX}
                   $/x
    # Mapping of atoms to wrappers.
    ATOMS = { 'B' => 'java/lang/Byte', 'S' => 'java/lang/Short', 'I' => 'java/lang/Integer', 'J' => 'java/lang/Long',
              'F' => 'java/lang/Float', 'D' => 'java/lang/Double', 'Z' => 'java/lang/Booleam', 'C' => 'java/lang/Character' }

    def self.valid?(string)
      string =~ ARRAY_REGEX || string =~ VALID_REGEX
    end

    def initialize(string, qualified=nil)
      super string

      if string =~ ARRAY_REGEX
        @is_array = string[/^\[+/].length
        string = string.sub(ARRAY_REGEX, '\1\2')
      else
        @is_array = false
      end

      if string =~ /^[A-Z]$/
        @is_atom = string
        string = ATOMS[string]
      else
        @is_atom = false
      end

      if string =~ VALID_REGEX
        @jvm_name = string
        @qualified_name = qualified
      else
        raise ArgumentError, "#{string} is no valid JVM name"
      end
    end

    def array?
      @is_array
    end

    def to_classname
      @qualified_name ||= JavaQualifiedName.new(@jvm_name.gsub(SEPARATOR, JavaQualifiedName::SEPARATOR))
    end

    def to_jvmname
      # TODO test if this method is called, not the delegated
      self
    end

    def to_class_file
      JavaClassFileName.new(@jvm_name + JavaLanguage::CLASS, self)
      # TODO lazy field
    end

  end

  # A Java class file name from the file system. That is <code>a/b/C.class</code>. These names are read from the FolderClasspath.
  # Author::          Peter Kofler
  class JavaClassFileName < String
    include JavaQualifiedNameDelegation

    SEPARATOR = '/'
    SEPARATOR_REGEX = /\/|\\/
    VALID_REGEX = /^
                    (?:   #{JavaLanguage::IDENTIFIER_REGEX}#{SEPARATOR_REGEX}   )*
                    #{JavaLanguage::IDENTIFIER_REGEX}
                    #{JavaLanguage::CLASS_REGEX}
                   /x

    def self.valid?(string)
      string =~ VALID_REGEX
    end

    def initialize(string, qualified=nil)
      super string
      if string =~ VALID_REGEX
        @file_name = string
        @qualified_name = qualified
      else
        raise ArgumentError, "#{string} is no valid class file name"
      end
    end

    def to_classname
      @qualified_name ||=
        JavaQualifiedName.new(
          @file_name.gsub(SEPARATOR_REGEX, JavaQualifiedName::SEPARATOR).
                     sub(JavaLanguage::CLASS_REGEX, '')
        )
    end

    def to_jvmname
      JavaVMName.new(@file_name.sub(JavaLanguage::CLASS_REGEX, ''), self)
      # TODO lazy
    end

    def to_class_file
      # TODO test if this method is called, not the delegated
      self
    end

  end

end

class String

  TYPES = [JavaClass::JavaClassFileName, JavaClass::JavaVMName, JavaClass::JavaPackageName, JavaClass::JavaQualifiedName]

  # Convert a Java classname or Java class filename to JavaName instance.
  # If it's a pathname then it must be relative to the classpath.
  def to_javaname

    # plain_name = string.sub(/(\.java|".*|\.<.*|;)?$/, '')
    match = TYPES.find { |type| type.valid?(self) }
    if match
      match.new(self)
    else
      raise "unknown #{self}"
    end
    #      plain_name = plain_name.sub(/^\[+L/, '')
    #      # TODO check this JVM codes
    #      plain_name = 'java.lang.Byte' if plain_name =~ /^\[+B$/ # byte array
    #      plain_name = 'java.lang.Integer' if plain_name =~ /^\[+I$/
    #      @full_name = plain_name
    #      @full_name = @full_name.gsub(/\/|\\/,'.')
    #      @full_name = self if @full_name == string # save some bytes
    #      raise 'internal error, full_name is empty' unless @full_name
    #
    #      matches = @full_name.scan(/^(.+)(?:\.|\/)([A-Z][^.\/]*)$/)[0]
    #      if matches
    #        @package = matches[0].gsub(/\/|\\/,'.')
    #        @simple_name = matches[1].gsub(/\/|\\/,'.')
    #      elsif @full_name =~ /^[A-Z][^.\/]*$/
    #        # simple name
    #        @package = ''
    #        @simple_name = self.gsub(/\/|\\/,'.')
    #      else
    #        # only package
    #        @package = self.gsub(/\/|\\/,'.')
    #        @simple_name = ''
    #      end
    #      package_remove_trailing_dot!
  end

end
