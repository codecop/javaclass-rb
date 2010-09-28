module JavaClass
  
  # Special string with methods to work with Java class or package names.
  # Author::          Peter Kofler
  class JavaName < String
    
    # Return the package name of a classname or the superpackage of a package. Return an empty String if default package.
    attr_reader :package
    
    # Return the simple name of this class or package.
    attr_reader :simple_name
    # Full normalized class name of this class.
    attr_reader :full_name
    
    def initialize(string)
      super string
      @full_name = string.gsub(/\/|\\/,'.').sub(/\.(class|java|".*|<.*)?$/, '')
      
      matches = @full_name.scan(/^(.+)\.([A-Z][^.]*)$/)[0]
      if matches
        @package = matches[0].to_javaname
        @simple_name = matches[1].to_javaname
      elsif @full_name =~ /^[A-Z][^.]*$/
        # simple name
        @package = ''
        @simple_name = self
      else
        # only package
        @package = self
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
      @full_name.to_javaname
    end
    
    # Return the VM name of this class, e.g. <code>java/lang/Object</code>.
    def to_jvmname
      (@full_name.gsub(/\./, '/')).to_javaname
    end
    
    # Return the Java source file name of this class, e.g. <code>java/lang/Object.java</code>.
    def to_java_file
      (to_jvmname + '.java').to_javaname
    end
    
    # Return the Java class file name of this class, e.g. <code>java/lang/Object.class</code>.
    def to_class_file
      (to_jvmname + '.class').to_javaname
    end
    
    # Split the simple name at the camel case boundary _pos_ and return two parts. _pos_ may
    # be < 0 for counting backwards.
    def split_simple_name(pos)
      parts = @simple_name.scan(/([A-Z][^A-Z]+)/).flatten
      pos = parts.size + pos +1 if pos < 0
      return ['', @simple_name] if pos <= 0
      return [@simple_name, ''] if pos >= parts.size
      [parts[0...pos].join, parts[pos..-1].join]
    end
  end
  
end

class String
  
  # Convert a Java classname or Java class filename to JavaClass::JavaName instance. 
  # If it's a pathname then it must be relative to the classpath.
  def to_javaname
    JavaClass::JavaName.new(self)
  end
  
end
