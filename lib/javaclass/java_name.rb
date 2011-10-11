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

  # A delegator to a String with only read only methods. This should delegate all methods to a inner _value_ but the modifying ones.
  # Author::          Peter Kofler
  class ReadOnlyString < ::Object
    include Enumerable
    include Comparable
    
    class << ::String
      include Kernel
    end

    extend DelegateDirective
        
    # Create a new pseude String _string_ .
    def initialize(string)
      @value = string
    end

    delegate_field :%, :value
    delegate_field :*, :value
    delegate_field :+, :value
    delegate_field :<=>, :value
    delegate_field :[], :value
    delegate_field :bytes, :value
    delegate_field :bytesize, :value
    delegate_field :capitalize, :value
    delegate_field :casecmp, :value
    delegate_field :center, :value
    delegate_field :chars, :value
    delegate_field :chomp, :value
    delegate_field :chop, :value
    delegate_field :crypt, :value
    delegate_field :delete, :value
    delegate_field :downcase, :value
    delegate_field :dump, :value
    delegate_field :each, :value
    delegate_field :each_byte, :value
    delegate_field :each_char, :value
    delegate_field :each_line, :value
    delegate_field :empty?, :value
    delegate_field :end_with?, :value
    delegate_field :gsub, :value
    delegate_field :hex, :value
    delegate_field :index, :value
    delegate_field :intern, :value
    delegate_field :length, :value
    delegate_field :lines, :value
    delegate_field :ljust, :value
    delegate_field :lstrip, :value
    delegate_field :match, :value
    delegate_field :next, :value
    delegate_field :oct, :value
    delegate_field :reverse, :value
    delegate_field :rindex, :value
    delegate_field :rjust, :value
    delegate_field :rpartition, :value
    delegate_field :rstrip, :value
    delegate_field :scan, :value
    delegate_field :size, :value
    delegate_field :slice, :value
    delegate_field :split, :value
    delegate_field :squeeze, :value
    delegate_field :start_with?, :value
    delegate_field :strip, :value
    delegate_field :sub, :value
    delegate_field :succ, :value
    delegate_field :sum, :value
    delegate_field :swapcase, :value
    delegate_field :to_a, :value
    delegate_field :to_f, :value
    delegate_field :to_i, :value
    delegate_field :to_str, :value
    delegate_field :to_sym, :value
    delegate_field :tr, :value
    delegate_field :tr_s, :value
    delegate_field :unpack, :value
    delegate_field :upcase, :value
    delegate_field :upto, :value
  end
  
  # A full qualified package name. That is like <code>a.b.c</code>.
  # Author::          Peter Kofler
  class JavaPackageName < String
    include PackageLogic

    SEPARATOR = '.'
    SEPARATOR_REGEX = Regexp::escape(SEPARATOR)
    VALID_REGEX = /^   (?:   #{JavaLanguage::IDENTIFIER_REGEX}#{SEPARATOR_REGEX}   )*
                       #{JavaLanguage::LOWER_IDENTIFIER_REGEX}#{SEPARATOR_REGEX}?   $/x

    # Is _string_ a valid package name?               
    def self.valid?(string)
      string =~ VALID_REGEX
    end

    # Create a new package name _string_.               
    def initialize(string)
      super string
      if string =~ VALID_REGEX
        @package = string
      else
        raise ArgumentError, "#{string} is no valid package name"
      end
      package_remove_trailing_dot!
    end

    def to_javaname
      self
    end

  end

  # A full qualified class name. That is like <code>a.b.C</code>.
  # Author::          Peter Kofler
  class JavaQualifiedName < String
    include PackageLogic
    include SimpleNameLogic

    SEPARATOR = '.'
    SEPARATOR_REGEX = Regexp::escape(SEPARATOR)
    VALID_REGEX = /^   (    (?:  #{JavaLanguage::IDENTIFIER_REGEX}#{SEPARATOR_REGEX}   )*   )
                       (   #{JavaLanguage::IDENTIFIER_REGEX}    )   $/x

    # Is _string_ a valid qualified name?               
    def self.valid?(string)
      string =~ VALID_REGEX
    end

    # Create a new qualified name _string_ with optional _jvmname_ and _classname_ classes which may be available.               
    def initialize(string, jvmname=nil, classname=nil)
      super string
      if string =~ VALID_REGEX
        @package = $1 || ''
        @simple_name = $2
        @full_name = string
      else
        # TODO implement for inner classes: CollectionUtils$IChecker
        raise ArgumentError, "#{string} is no valid qualified name"
      end
      package_remove_trailing_dot!
      
      @jvm_name = jvmname
      @class_name = classname
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
      @jvm_name ||= JavaVMName.new(@full_name.gsub(SEPARATOR, JavaVMName::SEPARATOR), self) 
    end

    # Return the Java source file name of this class, e.g. <code>java/lang/Object.java</code>. This is a plain String.
    def to_java_file
      @full_name.gsub(SEPARATOR, JavaClassFileName::SEPARATOR) + JavaLanguage::SOURCE
    end

    # Return the Java class file name of this class, e.g. <code>java/lang/Object.class</code>.
    def to_class_file
      # p self, self.class, @package, @simple_name, @full_name
      @class_name ||= JavaClassFileName.new(@full_name.gsub(SEPARATOR, JavaClassFileName::SEPARATOR) + JavaLanguage::CLASS, self)
    end

  end

  # Delegation of JavaQualifiedName's methods. The "mixer" needs to define a method
  # _to_classname_ which returns a JavaQualifiedName.
  # Author::          Peter Kofler
  module JavaQualifiedNameDelegation # :nodoc:
    extend DelegateDirective

    def to_javaname
      self
    end

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
    VALID_REGEX = /^   (?:   #{JavaLanguage::IDENTIFIER_REGEX}#{SEPARATOR_REGEX}   )*
                       #{JavaLanguage::IDENTIFIER_REGEX}   $/x
    # Mapping of atoms to wrappers.
    ATOMS = { 'B' => 'java/lang/Byte', 'S' => 'java/lang/Short', 'I' => 'java/lang/Integer', 'J' => 'java/lang/Long',
              'F' => 'java/lang/Float', 'D' => 'java/lang/Double', 'Z' => 'java/lang/Booleam', 'C' => 'java/lang/Character' }

    # Is _string_ a valid JVM name?               
    def self.valid?(string)
      string =~ ARRAY_REGEX || string =~ VALID_REGEX
    end

    # Create a new JVM name _string_ with optional _qualified_ class which may be available.               
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

    # Is this a bytecode array, e.g. represented by <code>[B</code>.
    def array?
      @is_array
    end

    def to_classname
      @qualified_name ||= JavaQualifiedName.new(@jvm_name.gsub(SEPARATOR, JavaQualifiedName::SEPARATOR), self, nil)
    end

    def to_jvmname
      self
    end

    def to_java_file
      @jvm_name + JavaLanguage::SOURCE
    end
    
    def to_class_file
      @class_name ||= JavaClassFileName.new(@jvm_name + JavaLanguage::CLASS, @qualified_name)
    end

  end

  # A Java class file name from the file system. That is <code>a/b/C.class</code>. 
  # These names are read from the FolderClasspath.
  # Author::          Peter Kofler
  class JavaClassFileName < String
    include JavaQualifiedNameDelegation

    SEPARATOR = '/'
    SEPARATOR_REGEX = /\/|\\/
    VALID_REGEX = /^   (?:   #{JavaLanguage::IDENTIFIER_REGEX}#{SEPARATOR_REGEX}   )*
                       #{JavaLanguage::IDENTIFIER_REGEX}
                       #{JavaLanguage::CLASS_REGEX}   /x

    # Is _string_ a valid class file name?               
    def self.valid?(string)
      string =~ VALID_REGEX
    end

    # Create a new class file name _string_ with optional _qualified_ class which may be available.               
    def initialize(string, qualified=nil)
      super string
      if string =~ VALID_REGEX
        @class_name = string.gsub(SEPARATOR_REGEX, SEPARATOR)
        @qualified_name = qualified
      else
        raise ArgumentError, "#{string} is no valid class file name"
      end
    end

    def to_classname
      @qualified_name ||= JavaQualifiedName.new(
            @class_name.gsub(SEPARATOR_REGEX, JavaQualifiedName::SEPARATOR).sub(JavaLanguage::CLASS_REGEX, ''),
        nil, self)
    end

    def to_jvmname
      @jvm_name ||= JavaVMName.new(@class_name.sub(JavaLanguage::CLASS_REGEX, ''), @qualified_name)
    end

    def to_java_file
      @class_name.sub(JavaLanguage::CLASS_REGEX, JavaLanguage::SOURCE)
    end
    
    def to_class_file
      self
    end

  end

end

class String

  TYPES = [JavaClass::JavaClassFileName, JavaClass::JavaVMName, JavaClass::JavaPackageName, JavaClass::JavaQualifiedName]

  # Convert a Java classname or Java class filename to special String with methods to work with Java 
  # class or package names. If it's a pathname then it must be relative to the classpath. 
  # Source extension and additional JVM method declarations are dropped.
  def to_javaname

    match = TYPES.find { |type| type.valid?(self) }
    if match
      return match.new(self)
    end

    plain_name = self.sub(/#{JavaClass::JavaLanguage::SOURCE_REGEX}|".*$|\.<.*$/, '').gsub(/\\/, '/')
    match = TYPES.find { |type| type.valid?(plain_name) }
    if match
      match.new(plain_name)
    else
      raise "unknown Java name #{self}"
    end
  end

end
