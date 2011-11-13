# Example usage of classpath and class files: Scan all classes of an Eclipse
# "workspace". Mark all referenced classes. Report unreferenced classes. This 
# lists *potential* unused classes. Note that the classes may still be used by
# reflection.
# Author::          Peter Kofler

#--
# add the lib of this gem to the load path
$:.unshift File.join(File.dirname(__FILE__), '..', 'lib')
require File.join(File.dirname(__FILE__), 'corpus')

location = Corpus[:RCP]
package1 = 'com.ibm.arc.sdm'
package2 = 'pricingTool'
#++
require 'javaclass/dsl/mixin'
require 'javaclass/classpath/tracking_classpath'

# speed up loading by skipping non source file classpaths
Eclipse.skip_lib

# 1) create the (tracking) CompositeClasspath of the given workspace
cp = workspace(location)
puts "#{cp.elements.size} classpaths found under the workspace #{location}:\n  #{cp.elements.join("\n  ")}"

# limit all operations to the classes we are interrested in
filter = Proc.new { |clazz| clazz.same_or_subpackage_of?(package1) || clazz.same_or_subpackage_of?(package2) }

# 2) load all classes in the given packages
puts 'loading all *filtered* classes... (can take several minutes)'
classes = cp.values(&filter)
puts "#{classes.size} classes loaded from classpaths"

# 3) mark all their referenced types in the given packages as accessed
cp.reset_access
classes.map { |clazz| clazz.imported_types }.flatten.
    find_all(&filter).
    each { |classname| cp.mark_accessed(classname) }
puts '*filtered* classes mapped'

# 4) also mark all classes referenced from config files
hardcoded_classnames = scan_config_for_3rd_party_class_names(location).find_all(&filter)
puts "#{hardcoded_classnames.size} classes references found in configs"
hardcoded_classnames.each { |classname| cp.mark_accessed(classname) }
puts 'hardcoded classes mapped'

# 5) mark unit tests (all classes ending in Test) on the test projects (projects ending in .test)
test_projects = cp.elements.find_all { |cpe| cpe.to_s =~ /\.test\// }
test_projects.each do |project|
  project.names { |classname| classname =~ /Test(?:Case|Suite|s)?\.class/ }.
      each { |classname| project.mark_accessed(classname) }
end
puts 'test classes mapped'

# 6) find non accessed classes and report unused in specific packages
unused_classes = classes.find_all { |clazz| cp.accessed(clazz) == 0 }
report = unused_classes.map { |clazz| "#{clazz.to_classname}" }
puts "#{report.size} unused classes found:\n  #{report.join("\n  ")}"
