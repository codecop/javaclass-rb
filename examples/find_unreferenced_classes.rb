# Example usage of classpath and class files: Scan all classes of an Eclipse
# "workspace". (A workspace is a folder containing several Eclipse projects.)
# Find all interfaces, print their names and find all which are prefixed with I.
# Author::          Peter Kofler

# add the lib of this gem to the load path
$:.unshift File.join(File.dirname(__FILE__), '..', 'lib')
require 'javaclass/classpath/tracking_classpath'
require 'javaclass/dsl/mixin'

workspace_location = 'C:\RTC3.0\workspaces\Costing_Dev'
package1 = 'com.ibm.arc.sdm'
package2 = 'pricingTool'

# speed up loading by skipping non source file classpaths
Eclipse.skip_lib

# 1) create the (tracking) CompositeClasspath of the given workspace
cp = workspace(workspace_location)
puts "#{cp.elements.size} classpaths found under the workspace #{workspace_location}:\n  #{cp.elements.join("\n  ")}"

filter = Proc.new { |clazz| clazz.same_or_subpackage_of?(package1) || clazz.same_or_subpackage_of?(package2) }

# 2) load all classes in the given packages
puts 'loading all *filtered* classes... (can take several minutes)'
classes = cp.values(&filter)
puts "#{classes.size} classes loaded from classpaths"
# TODO CONTINUE 6 - improve loading performance, why does it take so long to load 10.000 headers?
# use -r profile

# 3) mark all their referenced types in the given packages as accessed
cp.reset_access
classes.map { |clazz| clazz.imported_types }.flatten.
    find_all(&filter).
    each { |clazz| cp.mark_accessed(clazz) }
    puts 'all *filtered* classes mapped'

# 4) also mark all classes referenced from config files
hardcoded_classes = scan_config_for_class_names(workspace_location).find_all(&filter)
puts "#{hardcoded_classes.size} classes references found in configs"
hardcoded_classes.each { |clazz| cp.mark_accessed(clazz) }
puts 'all hardcoded classes mapped'

# 5) find non accessed classes
unused = cp.names(&filter).find_all { |clazz| !cp.accessed(clazz) }
puts "#{unused.size} unused classes found:\n  #{unused.join("\n  ")}"
