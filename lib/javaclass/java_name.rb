require 'javaclass/java_language'
require 'javaclass/delegate_directive'

module JavaClass

  # Mixin with logic to work with Java package names. The "mixer" needs to declare a String field @package.
  # Author::          Peter Kofler
  module PackageLogic

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
      packages.find {|pkg| @package =~ /^#{Regexp.escape(pkg)}#{JavaLanguage::SEPARATOR_REGEX}/ } != nil
    end

    # Is this package or class in the JDK? Return the first JDK package this is inside or nil.
    def in_jdk?
      if @package && @package != ''
        package_dot = @package + JavaLanguage::SEPARATOR
        JavaLanguage::JDK_PACKAGES_REGEX.find { |package| package_dot =~ package }
      else
        # default package is never in JDK
        false
      end
    end

    private

    def package_remove_trailing_dot!
      @package = @package[0..-2] if @package.size > 0 && @package[-1..-1] == JavaLanguage::SEPARATOR
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
  
  # A full qualified package name. That is like <code>a.b.c</code>.
  # Author::          Peter Kofler
  class JavaPackageName < String
    include PackageLogic

    VALID_REGEX = /^   (?:   #{JavaLanguage::IDENTIFIER_REGEX}#{JavaLanguage::SEPARATOR_REGEX}   )*
                       #{JavaLanguage::LOWER_IDENTIFIER_REGEX}#{JavaLanguage::SEPARATOR_REGEX}?   $/x

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

  # A full qualified class name. That is like <code>a.b.C</code>. Care has to be taken
  # if this is used as hash key. String is treated special and the additional fields are lost
  # when the key is retrieved from the Hash (because it is frozen). 
  # Author::          Peter Kofler
  class JavaQualifiedName < String
    include PackageLogic
    include SimpleNameLogic

    VALID_REGEX = /^   (    (?:  #{JavaLanguage::IDENTIFIER_REGEX}#{JavaLanguage::SEPARATOR_REGEX}   )*   )
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
        # TODO implement JavaQualifiedName for inner classes like CollectionUtils$IChecker
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
      return @jvm_name if @jvm_name
      new_val = JavaVMName.new(@full_name.gsub(JavaLanguage::SEPARATOR, JavaVMName::SEPARATOR), self)
      if frozen?
        new_val
      else
        @jvm_name = new_val
      end
    end

    # Return the Java source file name of this class, e.g. <code>java/lang/Object.java</code>. This is a plain String.
    def to_java_file
      @full_name.gsub(JavaLanguage::SEPARATOR, JavaClassFileName::SEPARATOR) + JavaLanguage::SOURCE
    end

    # Return the Java class file name of this class, e.g. <code>java/lang/Object.class</code>.
    def to_class_file
      return @class_name if @class_name
      new_val = JavaClassFileName.new(@full_name.gsub(JavaLanguage::SEPARATOR, JavaClassFileName::SEPARATOR) + JavaLanguage::CLASS, self)
      if frozen?
        new_val
      else 
        @class_name = new_val
      end 
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

        if string =~ /^[BSIJFDZC]$/
          @is_atom = string
          string = ATOMS[string]
        else
          @is_atom = false
        end
      
      else
        @is_array = false
      end

      if string =~ VALID_REGEX
        @jvm_name = string
      else
        raise ArgumentError, "#{string} is no valid JVM name"
      end
      @qualified_name = qualified
      @class_name = nil      
    end

    # Is this a bytecode array, e.g. represented by <code>[B</code>.
    def array?
      @is_array
    end

    def to_classname
      return @qualified_name if @qualified_name
      new_val = JavaQualifiedName.new(@jvm_name.gsub(SEPARATOR, JavaLanguage::SEPARATOR), self, nil)
      if frozen?
        new_val
      else 
        @qualified_name = new_val
      end 
    end

    def to_jvmname
      self
    end

    def to_java_file
      @jvm_name + JavaLanguage::SOURCE
    end
    
    def to_class_file
      return @class_name if @class_name
      new_val = JavaClassFileName.new(@jvm_name + JavaLanguage::CLASS, @qualified_name)
      if frozen?
        new_val
      else 
        @class_name = new_val
      end 
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

    # The plain file name of this class file.
    attr_reader :file_name
    
    # Create a new class file name _string_ with optional _qualified_ class which may be available.               
    def initialize(string, qualified=nil)
      super string
      if string =~ VALID_REGEX
        @file_name = string.gsub(SEPARATOR_REGEX, SEPARATOR)
      else
        raise ArgumentError, "#{string} is no valid class file name"
      end
      @qualified_name = qualified
      @jvm_name = nil
    end

    def to_classname
      return @qualified_name if @qualified_name
      new_val = JavaQualifiedName.new(
                    @file_name.gsub(SEPARATOR_REGEX, JavaLanguage::SEPARATOR).sub(JavaLanguage::CLASS_REGEX, ''),
                      nil, self)
      if frozen?
        new_val
      else 
        @qualified_name = new_val
      end 
    end

    def to_jvmname
      return @jvm_name if @jvm_name
      new_val = JavaVMName.new(@file_name.sub(JavaLanguage::CLASS_REGEX, ''), @qualified_name)
      if frozen?
        new_val
      else
        @jvm_name = new_val
      end
    end

    def to_java_file
      @file_name.sub(JavaLanguage::CLASS_REGEX, JavaLanguage::SOURCE)
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
      raise ArgumentError, "unknown Java name #{self}"
    end
  end

end
