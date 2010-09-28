$:.unshift File.join(File.dirname(__FILE__), '..', 'lib')
require 'javaclass/classlist/list'
require 'javaclass/classlist/jar_searcher'

# Generate the full class lists starting from a saved one.
# Author::          Peter Kofler
puts "create full class lists for JDKs (by search and open class)"

# Struct to keep configuration what kind of JDK classes should be searched and added.
JDK_CONFIG = Struct.new(:version, :label, :paths)
# Define information about JDK to process one after another.
JDKS = [
  JDK_CONFIG.new(0, "1.0.2",    ['E:\Develop\Java\Compiler\jdk1.0.2\lib']),
  JDK_CONFIG.new(1, "1.1.8-09", ['E:\Develop\Java\Compiler\jdk1.1.8\lib', 'E:\Develop\Java\JDK-1.1\Library\swing-1.1.1\lib']),
  JDK_CONFIG.new(2, "1.2.2-13", ['C:\Programme\Java\jdk1.2.2_13\jre\lib', 'C:\Programme\Java\jdk1.2.2_13\lib\dt.jar']),
  JDK_CONFIG.new(3, "1.3.1-08", ['C:\Programme\Java\jdk1.3.1_08\jre\lib', 'C:\Programme\Java\jdk1.3.1_08\lib\dt.jar']),
  JDK_CONFIG.new(4, "1.4.2-03", ['C:\Programme\Java\jdk1.4.2_03\jre\lib', 'C:\Programme\Java\jdk1.4.2_03\lib\dt.jar']),
  JDK_CONFIG.new(5, "1.5.0-07", ['C:\Programme\Java\jdk1.5.0_07\jre\lib', 'C:\Programme\Java\jdk1.5.0_07\lib\dt.jar']),
  JDK_CONFIG.new(6, "1.6.0-11", ['C:\Programme\Java\jdk1.6.0_21\jre\lib', 'C:\Programme\Java\jdk1.6.0_21\lib\dt.jar']),
  #JDK_CONFIG.new(7, "1.7.0-xx", ['C:\Programme\Java\jdk1.7.0_xx\jre\lib']),
]

BASE_NAME = 'fullClassList'

# Create a new list
@list = JavaClass::ClassList::List.new

# load already good list if we do not start with JDK 1.0
if JDKS[0].version > 0
  old_version = JDKS[0].version-1
  old_class_list_name = Dir["./#{BASE_NAME}?#{old_version}?.txt"].first
  if FileTest.exist?(old_class_list_name)
    puts "loading #{old_version}"
    IO.readlines(old_class_list_name).each {|line| @list.parse_line(line, old_version) }
  end
end

# init the searcher
@searcher = JavaClass::ClassList::JarSearcher.new
@searcher.filters = %w[sun/ sunw/ com/sun/ netscape/ COM/rsa/ quicktime/ com/apple/mrj/macos/carbon/ org/jcp/xml/dsig/internal/]
# netscape ... applet js security [2]
# COM/rsa/ ... jsafe [4]
# quicktime ... quicktime [5]
# org/jcp/xml/dsig/internal ... xml dsig [6]

#Dir.mkdir './ClassLists' unless File.exist? './ClassLists'

# Work on all lists defined in +JDK+ and yield the block with the jdk label and the class list.
JDKS.each do |conf|
  puts "processing #{conf.version}"
  conf.paths.each { |p| @list = @searcher.compile_list(conf.version, p, @list) }
  
  #basename = "jdk#{conf.label.gsub(/\./, '')}"
  #File.open("./ClassLists/#{basename}_new_package_classes.txt", "w") { |f| f.print @list.old_access_list.collect{|m| m.sub(/\s.*$/, '')} }
  #File.open("./ClassLists/#{basename}_all_classes.txt", "w") { |f| f.print @list.plain_class_list }
  #File.open("./ClassLists/#{basename}_all_public_classes.txt", "w") { |f| f.print @list.plain_class_list { |c| c.public? } }
  #File.open("./ClassLists/#{basename}_new_public_classes.txt", "w") { |f| f.print @list.plain_class_list { |c| c.public? and c.version.first == conf.version } }
  
  baseversion = conf.label.gsub(/\.|-.+$/, '')
  File.open("./#{BASE_NAME}#{baseversion}.txt", "w") { |f| f.print @list.full_class_list }
end
