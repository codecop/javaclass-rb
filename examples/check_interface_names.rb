# Example usage of classpath and class files: Scan all classes of an Eclipse
# "workspace". A workspace is a folder containing several Eclipse projects. 
# Find all interfaces, print their names and find all which are prefixed with 'I'.
# Author::          Peter Kofler

# add the lib of this gem to the load path
$:.unshift File.join(File.dirname(__FILE__), '..', 'lib')
require 'javaclass/dsl/mixin'

location = 'E:\Develop\Java'
package = 'at.kugel' 

# add an Eclipse classpath variable
Eclipse.add_variable('KOR_HOME', 'E:\Develop\Java')

# 1) create the CompositeClasspath of the given workspace
cp = workspace(location)
puts "#{cp.elements.size} classpaths found under the workspace #{location}:\n  #{cp.elements.join("\n  ")}"
puts "#{cp.count} classes found on classpath"

# 2) select classes to analyse
to_analyse = cp.names { |classname| classname.same_or_subpackage_of?(package) } 
puts "#{to_analyse.size} classes matched #{package}"

# 3) find all interfaces and collect their simple names
names = cp.values(to_analyse).find_all { |clazz| clazz.interface? }.collect { |clazz| clazz.to_classname }
puts "#{names.size} interfaces found:\n  #{names.sort.join("\n  ")}"

# 4) select all names that start with I and print them
inames = names.find_all { |classname| classname.simple_name =~ /^I[A-Z][a-z]/ }
puts "#{inames.size} interfaces start with I:\n  #{inames.join("\n  ")}"
