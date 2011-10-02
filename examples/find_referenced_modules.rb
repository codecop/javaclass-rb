# Example usage of classpath and class files: Scan all classes of an Eclipse
# "workspace". Use the classes of one module and find all modules which are not
# referenced. This lists unused libraries (classpaths).
# Author::          Peter Kofler

# add the lib of this gem to the load path
$:.unshift File.join(File.dirname(__FILE__), '..', 'lib')
require 'javaclass/classpath/tracking_classpath' # load tracking first!
require 'javaclass/dsl/mixin'
# require 'profile'

workspace_location = 'C:\Users\pkofler\Dropbox\InArbeit\DRY_Research\In the Wild\Java5_Servlets(HBD)'
workspace_location = 'C:\Users\pkofler\Dropbox\InArbeit\Corpus\Java5_Swing(BIA)'

# 1) create the CompositeClasspath of the given workspace
cp = workspace(workspace_location)
puts "#{cp.elements.size} classpaths found under the workspace #{workspace_location}:\n  #{cp.elements.join("\n  ")}"

# 2) create another classpath of the module under test 
main_classes = classpath(File.join(workspace_location, 'classes'), classpath(File.join(workspace_location, 'test-classes')))
puts "#{main_classes.names.size} classes found in main classpath"

# 3) mark all their referenced types as accessed in the workspace
cp.reset_access
main_classes.external_types.each { |clazz| cp.mark_accessed(clazz) }
puts 'all referenced classes mapped'

# 4) now find non accessed modules (i.e. classpath elements)
unused = cp.elements.find_all { |clp| !clp.accessed? }
puts "#{unused.size} unused modules found:\n  #{unused.join("\n  ")}"

p cp.elements.map { |clp| [clp.to_s, clp.accessed?] }
