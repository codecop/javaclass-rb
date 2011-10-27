# Example usage of classpath and class files: Scan all classes of an Eclipse
# "workspace". Use the classes of one module and find all modules which are not
# referenced. This lists *potential* unused libraries (classpaths). Note that the
# libraries may still be used from configuration files (e.g. Spring contexts) or
# from used libraries.
# Author::          Peter Kofler

# add the lib of this gem to the load path
$:.unshift File.join(File.dirname(__FILE__), '..', 'lib')
require 'javaclass/dsl/mixin'

location = "#{ENV['USERPROFILE']}\\Dropbox\\InArbeit\\Corpus\\Java6_Web(HBD)"
location = "#{ENV['USERPROFILE']}\\Dropbox\\InArbeit\\Corpus\\Java6_Swing(BIA)"

# 1) create a classpath of the module(s) under test 
main_classpath = classpath(File.join(location, 'classes'), classpath(File.join(location, 'test-classes')))
puts "#{main_classpath.count} classes found in main classpath:\n  #{main_classpath.elements.join("\n  ")}"

# 2) load tracking before creating new classpaths
require 'javaclass/classpath/tracking_classpath' 

# 3) create the (tracking) CompositeClasspath of the given workspace
cp = workspace(location)
puts "#{cp.elements.size} classpaths found under the workspace #{location}:\n  #{cp.elements.join("\n  ")}"
puts "#{cp.count} classes found in classpaths"

# 4) mark all their referenced types as accessed in the workspace
puts 'mapping referenced classes... (can take several minutes)'
cp.reset_access
main_classpath.external_types.each { |clazz| cp.mark_accessed(clazz) }
puts 'referenced classes mapped'

# 5a) now find non accessed modules/libraries (i.e. classpath elements)
unused = cp.elements.find_all { |clp| clp.jar? && clp.accessed == 0 }
puts "\n#{unused.size} unused modules found:\n  #{unused.join("\n  ")}"

# 5b) or print the list of classpath elements with access
puts "\nlibrary (module path): number of accessed classes"
puts cp.elements.map { |clp| [clp.to_s, clp.accessed] }.sort { |a,b| a[1] <=> b[1] }.map { |e| "  #{e[0]}: #{e[1]}" }

# TODO CONTINUE 6 - improve loading performance, why does it take so long to load 10.000 headers?
# use -r profile
