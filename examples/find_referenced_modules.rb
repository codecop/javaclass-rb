# Example usage of classpath and class files: Scan all classes of an Eclipse
# "workspace". Use the classes of one module and find all modules which are not
# referenced. This lists unused libraries (classpaths).
# Author::          Peter Kofler

# add the lib of this gem to the load path
$:.unshift File.join(File.dirname(__FILE__), '..', 'lib')
require 'javaclass/classpath/tracking_classpath'
require 'javaclass/dsl/mixin'

workspace_location = 'C:\Users\IBM_ADMIN\Dropbox\InArbeit\DRY_Research\In the Wild\Java5_Servlets(HBD)'
package = at.herold.*

# 1) create the CompositeClasspath of the given workspace
cp = workspace(workspace_location)
puts "#{ws.elements.size} classpaths found under the workspace #{workspace_location}:\n  #{ws.elements.join("\n  ")}"

# 2) create another classpath of the module under test and load all classes 
classes = classpath(File.join(workspace_location, 'classes')).values
puts "#{classes.size} classes loaded from classpaths"

# 3) mark all their referenced types as accessed in the workspace
cp.reset_access
classes.map { |clazz| clazz.imported_types }.flatten.
   each { |clazz| cp.mark_accessed(clazz) }
puts 'all classes mapped'

# 4) now find non accessed modules (i.e. classpath elements)
unused = cp.elements.find_all { |clp| !clp.accessed? }
puts "#{unused.size} unused modules found:\n  #{unused.join("\n  ")}"

p cp.elements.map { |clp| [clp.to_s, clp.accessed?] }
