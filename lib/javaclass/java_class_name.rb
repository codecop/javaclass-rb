module JavaClass
  
  # Special string with methods to work with Java class or package names.
  # Author::          Peter Kofler
  class JavaClassName < String
    
    # Return the package name of a classname or the superpackage of a package. Return an empty String if default package.
    attr_reader :package
    
    # Return the simple name of this class or package.
    attr_reader :simple_name
    attr_reader :full_name
    
    def initialize(string, class_name)
      super string
      @full_name = class_name
      
      matches = class_name.scan(/^(.+)\.([A-Z][^.]*)$/)[0]
      if matches
        @package = matches[0]
        @simple_name = matches[1].to_javaname
      elsif class_name =~ /^[A-Z][^.]*$/
        @package = ''
        @simple_name = class_name
      else
        @package = class_name
        @simple_name = ''
      end
    end
    
    # TODO Returnwerte aller Classnames diesen verwenden.
    
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

    def to_classname
      @full_name
    end
    
    def to_jvmname
      @full_name.gsub(/\./, '/')
    end
    
    def to_java_filename
      @full_name.gsub(/\./, '/') + '.java'
    end
    
    def to_class_filename
      @full_name.gsub(/\./, '/') + '.class'
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
  
  # Convert a Java classname or Java class filename to +JavaClassName+ instance. 
  # If it's a pathname then it must be relative to the classpath.
  def to_javaname
    class_name = self.gsub(/\/|\\/,'.').sub(/\.(class|java)?$/,'')
    JavaClass::JavaClassName.new(self, class_name)
  end
  
end
