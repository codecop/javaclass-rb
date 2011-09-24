# Example usage of classpath and class files: Scan all classes of an Eclipse
# workspace and print the names of interfaces, if they are prefixed with I or not.
# Author::          Peter Kofler

# add the lib of this gem to the load path
$:.unshift File.dirname(File.dirname(File.dirname(__FILE__)))
require 'javaclass/dsl/dsl'

workspace_location = 'C:\RPC3\workspace'
package_matcher = /^com\.ibm\.arc\.sdm/

# 1) create the CompositeClasspath of that workspace
# add an Eclipse classpath variable
# JavaClass::Classpath::EclipseClasspath::add_variable('KOR_HOME', 'E:\Develop\Java')
cp = workspace(workspace_location)
puts "#{cp.elements.size} classpaths found in the workspace:\n  #{cp.elements.join("\n  ")}"
puts "#{cp.count} classes found in all classpaths"

# 2) select our classes
puts "#{cp.names { |clazz| clazz.package =~ package_matcher }.size} classes matched #{package_matcher}"

# 3) find all interfaces and collect their simple names
names = cp.values { |clazz| clazz.package =~ matcher  }.
           find_all { |clazz| clazz.access_flags.interface? && !clazz.access_flags.annotation? }.
           collect { |clazz| clazz.name.simple_name }
puts "#{names.size} interfaces found:\n  #{names.sort.join("\n  ")}"

# 4) select interfaces that start with I and output them
inames = names.find_all { |name| name =~ /^I[A-Z]/ }
puts "#{inames.size} interfaces start with I:\n  #{inames.join("\n  ")}"
