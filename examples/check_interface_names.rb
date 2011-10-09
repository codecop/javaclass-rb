# Example usage of classpath and class files: Scan all classes of an Eclipse
# "workspace". A workspace is a folder containing several Eclipse projects. 
# Find all interfaces, print their names and find all which are prefixed with I.
# Author::          Peter Kofler

# add the lib of this gem to the load path
$:.unshift File.join(File.dirname(__FILE__), '..', 'lib')
require 'javaclass/dsl/mixin'

workspace_location = 'E:\Develop\Java'
package = 'at.kugel' 

# add an Eclipse classpath variable
Eclipse.add_variable('KOR_HOME', 'E:\Develop\Java')

# 1) create the CompositeClasspath of the given workspace
cp = workspace(workspace_location)
puts "#{cp.elements.size} classpaths found under the workspace #{workspace_location}:\n  #{cp.elements.join("\n  ")}"
puts "#{cp.count} classes found in all classpaths"

# 2) select our classes
puts "#{cp.names { |clazz| clazz.same_or_subpackage_of?(package) }.size} classes matched #{package}"

# 3) find all interfaces and collect their simple names
names = cp.values { |clazz| clazz.same_or_subpackage_of?(package) }.
           find_all { |clazz| clazz.access_flags.interface? && !clazz.access_flags.annotation? }.
           collect { |clazz| clazz.to_classname }
puts "#{names.size} interfaces found:\n  #{names.sort.join("\n  ")}"

# 4) select all names that start with I and print them
inames = names.find_all { |name| name.simple_name =~ /^I[A-Z]/ }
puts "#{inames.size} interfaces start with I:\n  #{inames.join("\n  ")}"
