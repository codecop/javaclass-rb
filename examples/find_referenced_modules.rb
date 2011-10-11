# Example usage of classpath and class files: Scan all classes of an Eclipse
# "workspace". Use the classes of one module and find all modules which are not
# referenced. This lists unused libraries (classpaths).
# Author::          Peter Kofler

# add the lib of this gem to the load path
$:.unshift File.join(File.dirname(__FILE__), '..', 'lib')
require 'javaclass/dsl/mixin'

workspace_location = "#{ENV['USERPROFILE']}\\Dropbox\\InArbeit\\Corpus\\Java6_Web(HBD)"
#workspace_location = "#{ENV['USERPROFILE']}\\Dropbox\\InArbeit\\Corpus\\Java6_Swing(BIA)"

# 1) create a classpath of the module(s) under test 
main_classes = classpath(File.join(workspace_location, 'classes'), classpath(File.join(workspace_location, 'test-classes')))
puts "#{main_classes.names.size} classes found in main classpath:\n  #{main_classes.elements.join("\n  ")}"

# 2) load tracking before creating new classpaths
require 'javaclass/classpath/tracking_classpath' 

# 3) create the (tracking) CompositeClasspath of the given workspace
cp = workspace(workspace_location)
puts "#{cp.elements.size} classpaths found under the workspace #{workspace_location}:\n  #{cp.elements.join("\n  ")}"

# 4) mark all their referenced types as accessed in the workspace
puts 'mapping referenced classes... (can take several minutes)'
cp.reset_access
main_classes.external_types.each { |clazz| cp.mark_accessed(clazz) }
puts 'all referenced classes mapped'

# 5) now find non accessed modules (i.e. classpath elements)
unused = cp.elements.find_all { |clp| !clp.accessed? && clp.jar? }
puts "#{unused.size} unused modules found:\n  #{unused.join("\n  ")}"

# puts cp.elements.map { |clp| "#{clp.to_s}: #{clp.accessed?}" }
