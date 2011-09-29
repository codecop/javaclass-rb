# Example usage of classpath and class files: Scan all classes of an Eclipse
# "workspace". A workspace is a folder containing several Eclipse projects. 
# Find all interfaces, print their names and find all which are prefixed with I.
# Author::          Peter Kofler

# add the lib of this gem to the load path
$:.unshift File.join(File.dirname(__FILE__), '..', 'lib')
require 'javaclass/classpath/tracking_classpath'
require 'javaclass/dsl/mixin'

workspace_location = 'C:\RTC3.0\workspaces\Costing_Dev'
package1 = com.ibm.arc.sdm.*
package2 = 'pricingTool'

Eclipse.skip_lib

# 1) create the CompositeClasspath of the given workspace
cp = workspace(workspace_location)
puts "#{cp.elements.size} classpaths found under the workspace #{workspace_location}:\n  #{cp.elements.join("\n  ")}"

filter = Proc.new { |clazz| clazz.same_or_subpackage_of?(package1) || clazz.same_or_subpackage_of?(package2) }

# 2) load all my classes and mark all their referenced types as accessed
classes = cp.values(&filter)
puts "#{classes.size} classes loaded from classpaths"

# 3) mark all their referenced types as accessed
classes.map { |clazz| clazz.imported_types }.flatten.
   find_all(&filter).
   each { |clazz| cp.mark_accessed(clazz) }
puts 'all classes mapped'

# 4) find non accessed ones
unused = cp.names(&filter).
   find_all { |clazz| !cp.accessed?(clazz) }
puts "#{unused.size} unused classes found"
     
puts unused

# TODO CONTINUE 6 - improve loading performance, why does it take so long to load 10.000 headers?
# use -r profile
