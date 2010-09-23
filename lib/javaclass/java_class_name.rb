# Special string with methods to work with Java class or package names.
# Author::          Kugel, <i>Theossos Comp Group</i>
class JavaClassName < String
  
  # TODO Returnwerte aller Classnames diesen verwenden.
  
  # Return the package name of a classname or the superpackage of a package. Return an empty String if default package.
  def package
    matches = self.scan(/^(.+)\./)[0]
    if matches
      matches[0]
    else
      ''
    end
  end
  
  # Return the simple name of this class or package.
  def simple_name
    matches = self.scan(/\.([^.]+)$/)[0]
    if matches
      matches[0]
    else
      self
    end
  end
  
  # Return true if this class is same or in a subpackage of the given Java _packages_ or
  # if this package is same or a subpackage (with .).  
  def same_or_subpackage?(packages)
    packages.find {|pkg| self == pkg || self =~ /^#{Regexp.escape(pkg)}\./ } != nil
  end
  
  # Return true if this class is in a subpackage of the given Java _packages_ .  
  def subpackage?(packages)
    packages.find {|pkg| self =~ /^#{Regexp.escape(pkg)}\./ } != nil
  end
  
  def to_classname
    self
  end
  
  def to_java_filename
    self.gsub(/\./, '/') + ".java"
  end
  
  def to_class_filename
    self.gsub(/\./, '/') + ".class"
  end
  
  # Split the simple name at the camel case boundary _pos_ and return two parts. _pos_ may
  # may < 0 for counting backwards. 
  def split_simple_name(pos)
    sn = simple_name
    parts = sn.scan(/([A-Z][^A-Z]+)/).flatten
    pos = parts.size + pos +1 if pos < 0
    return ['', sn] if pos <= 0 
    return [sn, ''] if pos >= parts.size
    [parts[0...pos].join, parts[pos..-1].join]
  end
end

class String
  # Convert a Java classname or Java class filename to JavaClassName instance. 
  def to_classname
    class_name = self.gsub(/\/|\\/,'.').sub(/\.$|\.class$/,'')
    JavaClassName.new(class_name)
  end
end