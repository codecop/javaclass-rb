# Example usage of classpath and class files: Scan all classes of an Eclipse
# "workspace". A workspace is a folder containing several Eclipse projects. 
# Find all interfaces, print their names and find all which are prefixed with I.
# Author::          Peter Kofler

# add the lib of this gem to the load path
$:.unshift File.join(File.dirname(__FILE__), '..', 'lib')
require 'javaclass/dsl/mixin'

workspace_location = 'E:\Develop\Java'
package_matcher = /^at\.kugel\./ # /^com\.ibm\.arc\.sdm/

# add an Eclipse classpath variable
JavaClass::Classpath::EclipseClasspath::add_variable('KOR_HOME', 'E:\Develop\Java')

# 1) create the CompositeClasspath of the given workspace
cp = workspace(workspace_location)
puts "#{cp.elements.size} classpaths found under the workspace #{workspace_location}:\n  #{cp.elements.join("\n  ")}"
puts "#{cp.count} classes found in all classpaths"

# 2) select our classes
puts "#{cp.names { |clazz| clazz.package =~ package_matcher }.size} classes matched #{package_matcher}"

# 3) find all interfaces and collect their simple names
names = cp.values { |clazz| clazz.package =~ package_matcher  }.
           find_all { |clazz| clazz.access_flags.interface? && !clazz.access_flags.annotation? }.
           collect { |clazz| clazz.name.simple_name }
puts "#{names.size} interfaces found:\n  #{names.sort.join("\n  ")}"

# 4) select all names that start with I and print them
inames = names.find_all { |name| name =~ /^I[A-Z]/ }
puts "#{inames.size} interfaces start with I:\n  #{inames.join("\n  ")}"
