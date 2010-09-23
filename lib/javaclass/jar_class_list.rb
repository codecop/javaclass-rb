require 'zip/zipfilesystem'
require File.expand_path(File.dirname(__FILE__) + '/java_class_header')

# Search in zip or jar files for Java class files, check for package access or inner classes and 
# create a list of all these. 
# Author::          Kugel, <i>Theossos Comp Group</i>
class JarClassList
  
  attr_accessor :skip_inner_classes
  attr_accessor :skip_package_classes
  
  # Create a new searcher. 
  def initialize
    @skip_inner_classes = true
    @skip_package_classes = false
    @package_filters = []
  end
  
  # The given _filters_ will be dropped during searching. 
  # _filters_ contain the beginning of package paths, i.e. <code>com/sun/</code>.
  def filters=(filters)
    @package_filters = filters.collect{ |f| /^#{f}/ }
  end
  
  # Search the given _path_ recursievely for zips or jars. Changes the current directory. 
  def find_jars(path)
    if FileTest.file?(path) and path =~ /\.jar$|\.zip$/
      return File.expand_path(path)
    end
    
    Dir.chdir File.expand_path(path)
    
    list = Dir['*'].collect do |name|
      if FileTest.directory?(name)
        find_jars(name)  
      elsif name =~ /\.jar$|\.zip$/
        File.expand_path(name)
      else
        nil
      end
    end
    
    Dir.chdir '..'
    
    list.flatten.reject{ |e| e.nil? }
  end
  
  # Return the list of classnames found in this _jarfile_ . 
  # Skips inner classes if +skip_inner_classes+ is true. 
  # Skips classes that are in the filtered packages.
  def list_classes(jarfile)
    classes = []
    Zip::ZipFile.foreach(jarfile) do |entry|
      name = entry.name
      next unless entry.file? and name =~ /\.class$/ # class file
      next if @skip_inner_classes and name =~ /\$/ 
      next if @package_filters.find { |filter| name =~ filter } 
      classes << name 
    end
    classes
  end
  
  # Return true if the _classfile_ in the given _jarfile_ is public. This is expensive because
  # the _jarfile_ is opened and the _classfile_ is extracted and read.
  def public?(jarfile, classfile)
    header = 
    Zip::ZipFile.open(jarfile) do |zipfile|
      JavaClassHeader.new(classfile, zipfile.file.read(classfile) )
    end
    raise "invalid java class #{classfile}" unless header.valid?
    header.accessible?
  end
  
  # Compile the class list for the given _version_ of Java. This searches the _path_ for zips and jars 
  # and adds them to the given _list_ of found classes. _version_ is a number >= 0, e.g. 2 for JDK 1.2.
  # _list_ must provide a <code>add_class(entry, is_public, version)</code> method.
  def compile_list(version, path, list)
    current = Dir.getwd
    
    find_jars(path).each do |jar| 
      list_classes(jar).each do |entry| 
        is_public = public?(jar, entry)
        next if @skip_package_classes and !is_public
        list.add_class(entry, is_public, version)   
      end
    end
    
    Dir.chdir File.expand_path(current)
    list
  end
  
end
