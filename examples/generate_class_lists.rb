# Generate a JavaClass::ClassList, which contains all class 
# names with version numbers when introduced. The list is created 
# iterating all JDKs, opening the RT.jars and loading all classes.
# Author::          Peter Kofler
# Copyright::       Copyright (c) 2009, Peter Kofler.
# License::         {BSD License}[link:/files/license_txt.html]
#
# === Usage

#--
# add the lib of this gem to the load path
$:.unshift File.join(File.dirname(__FILE__), '..', 'lib')
#++
require 'javaclass/classlist/jar_searcher'
require 'javaclass/classpath/jar_classpath'
require 'javaclass/classlist/list'

# Struct to keep configuration what kind of JDK classes should be searched and added.
JDK_CONFIG = Struct.new(:version, :label, :paths)

#--
# Windows 7 configuration for 32bit Sun/Oracle JVMs
PROGRAMS = 'C:\Program Files (x86)\Java'
JDKS = [
  JDK_CONFIG.new(0, '1.0.2',    ['E:\Develop\Java\Compiler\jdk1.0.2\lib']),
  JDK_CONFIG.new(1, '1.1.8-09', ['E:\Develop\Java\Compiler\jdk1.1.8\lib', 'E:\Develop\Java\JDK-1.1\Library\swing-1.1.1\lib']),
  JDK_CONFIG.new(2, '1.2.2-13', [PROGRAMS + '\jdk1.2.2_13\jre\lib', PROGRAMS + '\jdk1.2.2_13\lib\dt.jar']),
  JDK_CONFIG.new(3, '1.3.1-08', [PROGRAMS + '\jdk1.3.1_08\jre\lib', PROGRAMS + '\jdk1.3.1_08\lib\dt.jar']),
  JDK_CONFIG.new(4, '1.4.2-03', [PROGRAMS + '\jdk1.4.2_03\jre\lib', PROGRAMS + '\jdk1.4.2_03\lib\dt.jar']),
  JDK_CONFIG.new(5, '1.5.0-07', [PROGRAMS + '\jdk1.5.0_07\jre\lib', PROGRAMS + '\jdk1.5.0_07\lib\dt.jar']),
  JDK_CONFIG.new(6, '1.6.0-26', [PROGRAMS + '\jdk1.6.0_26\jre\lib', PROGRAMS + '\jdk1.6.0_26\lib\dt.jar']),
  JDK_CONFIG.new(7, '1.7.0',    [PROGRAMS + '\jdk1.7.0\jre\lib',    PROGRAMS + '\jdk1.7.0\lib\dt.jar']),
  JDK_CONFIG.new(8, '1.8.0',    [PROGRAMS + '\jdk1.8.0_25\jre\lib', PROGRAMS + '\jdk1.8.0_25\lib\dt.jar']),
]
#++
# configuration for some JDKs
#  JDKS = [ JDK_CONFIG.new(...), ... ]

# 1) create a JavaClass::ClassList::JarSearcher
JavaClass.unpack_jars!(:unpack)
searcher = JavaClass::ClassList::JarSearcher.new
searcher.skip_inner_classes = false

# 2) filter out unwanted classes, e.g. vendor classes
searcher.filters = %w[sun/ sunw/ com/oracle/ com/sun/ netscape/ COM/rsa/ 
         quicktime/ com/apple/mrj/macos/carbon/ org/jcp/xml/dsig/internal/]
#--
# netscape ... applet js security [2]
# COM/rsa/ ... jsafe [4]
# quicktime ... quicktime [5]
# org/jcp/xml/dsig/internal ... xml dsig [6]
# com/oracle/ ... com.oracle.net.Sdp [7]

Dir.mkdir './ClassLists' unless File.exist? './ClassLists'
#++

# 3) create a new JavaClass::ClassList::List to contain the classes
list = JavaClass::ClassList::List.new

#--
# load an already good list if we do not start with JDK 1.0
if JDKS[0].version > 0
  full_class_list_version = JDKS[0].version - 1
  full_class_list = "fullClassList1#{full_class_list_version}0.txt"
  IO.readlines(full_class_list).each {|line| list.parse_line(line, full_class_list_version) }
  puts "loaded full class list #{full_class_list} with versions #{list.version}"
end
#++

# Work on all lists defined in +JDKS+, add to the list and write list files.
JDKS.each do |conf|
  # 4) iterate JARs and compile a list
  conf.paths.each { |p| list = searcher.compile_list(conf.version, p, list) }

  # 5) save various kind of lists
  basename = "./ClassLists/jdk#{conf.label.gsub(/\./, '')}"
  File.open("#{basename}_new_package_classes.txt", "w") { |f| f.print list.old_access_list.collect{|m| m.sub(/\s.*$/, '')} }
  File.open("#{basename}_all_classes.txt", "w") { |f| f.print list.plain_class_list }
  File.open("#{basename}_all_packages.txt", "w") { |f| f.print list.to_s }
  File.open("#{basename}_all_public_classes.txt", "w") { |f| f.print list.plain_class_list { |c| c.public? } }
  File.open("#{basename}_new_public_classes.txt", "w") { |f| f.print list.plain_class_list { |c| c.public? and c.version.first == conf.version } }

  baseversion = conf.label.gsub(/\.|-.+$/, '')
  File.open("./fullClassList#{baseversion}.txt", "w") { |f| f.print list.full_class_list }

  puts "processed #{conf.label}"
end
