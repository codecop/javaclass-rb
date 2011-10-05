require 'javaclass/java_language'
require 'javaclass/delegate_directive'

module JavaClass
  
  class JavaQualifiedName < String
  
    # Return the package name of a classname or the name of the package. Return an empty String if default package.
    # This returns just the plain String.
    def package
      @package
    end

    # Return the simple name of this class or package.
    # This returns just the plain String.
    def simple_name
      @simple_name
    end

    # Full normalized class name of this class.
    # This returns just the plain String.
    def full_name
      @full_name
    end

    SEPARATOR = '.'
    VALID_REGEX = /^
                    ((?:#{JavaLanguage::IDENTIFIER_REGEX}#{Regexp.escape(SEPARATOR)})*)
                    (#{JavaLanguage::IDENTIFIER_REGEX})
                   $/x

    def initialize(string)
      super string
      if string =~ VALID_REGEX
        @package = $1
        @simple_name = $2
        @package = @package[0..-2] if @package.size > 0 && @package[-1..-1] == SEPARATOR
        @full_name = string
      else
        raise "#{string} is no valid qualified name"
      end
    end

    # Return +true+ if this class is in same or in a subpackage of the given Java _packages_ or
    # if this package is same or a subpackage (with .).
    def same_or_subpackage_of?(packages)
      packages.find {|pkg| @package == pkg } != nil || subpackage_of?(packages)
    end

    # Return +true+ if this class is in a subpackage of the given Java _packages_ .
    def subpackage_of?(packages)
      packages.find {|pkg| @package =~ /^#{Regexp.escape(pkg)}\./ } != nil
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
      JavaVMName.new(@full_name.dot_to_slash) # TODO lazy field
    end

    # Return the Java source file name of this class, e.g. <code>java/lang/Object.java</code>.
    def to_java_file
      (to_jvmname + JavaLanguage::SOURCE).to_javaname # TODO lazy field
    end

    # Return the Java class file name of this class, e.g. <code>java/lang/Object.class</code>.
    def to_class_file
      (to_jvmname + JavaLanguage::CLASS).to_javaname # TODO lazy field
    end

    # Split the simple name at the camel case boundary _pos_ and return two parts. _pos_ may be < 0 for counting backwards.
    def split_simple_name(pos)
      parts = @simple_name.scan(/([A-Z][^A-Z]+)/).flatten
      pos = parts.size + pos +1 if pos < 0
      return ['', @simple_name] if pos <= 0
      return [@simple_name, ''] if pos >= parts.size
      [parts[0...pos].join, parts[pos..-1].join]
    end

    # Is this package or class in the JDK?
    def in_jdk?
      JavaLanguage::JDK_PACKAGES_REGEX.find { |package| @full_name =~ package } != nil
    end
  end

  # TODO implement for inner classes: CollectionUtils$IChecker

  # Special String with methods to work with Java class or package names.
  # Author::          Peter Kofler
  class JavaName < String
    # Return the package name of a classname or the name of the package. Return an empty String if default package.
    # This returns just the plain String.
    def package
      @package
    end

    # Return the simple name of this class or package.
    # This returns just the plain String.
    def simple_name
      @simple_name
    end

    # Full normalized class name of this class.
    # This returns just the plain String.
    def full_name
      @full_name
    end

    def initialize(string)
      super string

      plain_name = string.sub(/(\.class|\.java|".*|\.<.*|;)?$/, '')
      plain_name = plain_name.sub(/^\[+L/, '')
      # TODO check this JVM codes
      plain_name = 'java.lang.Byte' if plain_name =~ /^\[+B$/ # byte array
      plain_name = 'java.lang.Integer' if plain_name =~ /^\[+I$/
      @full_name = plain_name
      @full_name = @full_name.gsub(/\/|\\/,'.')
      @full_name = self if @full_name == string # save some bytes
      raise 'internal error, full_name is empty' unless @full_name

      matches = @full_name.scan(/^(.+)(?:\.|\/)([A-Z][^.\/]*)$/)[0]
      if matches
        @package = matches[0].gsub(/\/|\\/,'.')
        @simple_name = matches[1].gsub(/\/|\\/,'.')
      elsif @full_name =~ /^[A-Z][^.\/]*$/
        # simple name
        @package = ''
        @simple_name = self.gsub(/\/|\\/,'.')
      else
        # only package
        @package = self.gsub(/\/|\\/,'.')
        @simple_name = ''
      end
    end

    # Return +true+ if this class is in same or in a subpackage of the given Java _packages_ or
    # if this package is same or a subpackage (with .).
    def same_or_subpackage_of?(packages)
      packages.find {|pkg| @package == pkg } != nil || subpackage_of?(packages)
    end

    # Return +true+ if this class is in a subpackage of the given Java _packages_ .
    def subpackage_of?(packages)
      packages.find {|pkg| @package =~ /^#{Regexp.escape(pkg)}\./ } != nil
    end

    def to_javaname
      self
    end

    # Return the full classname of this class, e.g. <code>java.lang.Object</code>.
    def to_classname
      if @full_name == self
        self
      else
        JavaQualifiedName.new(@full_name) # TODO init lazy?
      end
    end

    # Return the VM name of this class, e.g. <code>java/lang/Object</code>.
    def to_jvmname
      JavaVMName.new(@full_name.dot_to_slash)
    end

    # Return the Java source file name of this class, e.g. <code>java/lang/Object.java</code>.
    def to_java_file
      (to_jvmname + JavaLanguage::SOURCE).to_javaname # TODO needs to be transitive
    end

    # Return the Java class file name of this class, e.g. <code>java/lang/Object.class</code>.
    def to_class_file
      (to_jvmname + JavaLanguage::CLASS).to_javaname # TODO needs to be transitive
    end

    # Split the simple name at the camel case boundary _pos_ and return two parts. _pos_ may be < 0 for counting backwards.
    def split_simple_name(pos)
      parts = @simple_name.scan(/([A-Z][^A-Z]+)/).flatten
      pos = parts.size + pos +1 if pos < 0
      return ['', @simple_name] if pos <= 0
      return [@simple_name, ''] if pos >= parts.size
      [parts[0...pos].join, parts[pos..-1].join]
    end

    # Is this package or class in the JDK?
    def in_jdk?
      JavaLanguage::JDK_PACKAGES_REGEX.find { |package| @full_name =~ package } != nil
    end

  end

  # A class name from the JVM. That is a/b/C. These names are read from the constant pool.
  class JavaVMName < String
    extend DelegateDirective

    SEPARATOR = '/'
    VALID_REGEX = /^
                    (?:#{JavaLanguage::IDENTIFIER_REGEX}#{Regexp::escape(SEPARATOR)})*
                    #{JavaLanguage::IDENTIFIER_REGEX}
                   $/x
    
    def initialize(string)
      super string
      if string =~ VALID_REGEX
        @jvm_name = string
      else
        raise "#{string} is no valid JVM name"
      end 
    end

    def to_jvmname
      self
    end

    def to_classname
      @qualified_name = JavaQualifiedName.new(@jvm_name.gsub(SEPARATOR, JavaQualifiedName::SEPARATOR)) # TODO lazy init
    end

    delegate :package, :to_classname
    delegate :simple_name, :to_classname
    delegate :full_name, :to_classname
    delegate :same_or_subpackage_of?, :to_classname
    delegate :subpackage_of?, :to_classname
    delegate :to_java_file, :to_classname
    delegate :to_class_file, :to_classname
    delegate :split_simple_name, :to_classname
    delegate :in_jdk?, :to_classname
    delegate :to_javaname, :to_classname
  end

end

class String
  # Convert a Java classname or Java class filename to JavaName instance.
  # If it's a pathname then it must be relative to the classpath.
  def to_javaname
    JavaClass::JavaName.new(self)
  end

  # Replace all dots in this String with slashes.
  def dot_to_slash
    gsub('.', '/')
  end

  # Replace all slashes in this String with dots.
  def slash_to_dot
    gsub(/\/|\\/, '.')
  end

end
