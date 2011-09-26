# Example usage of classpath and class files: Scan all classes of an Eclipse
# "workspace". A workspace is a folder containing several Eclipse projects. 
# Find all interfaces, print their names and find all which are prefixed with I.
# Author::          Peter Kofler

# add the lib of this gem to the load path
$:.unshift File.join(File.dirname(__FILE__), '..', 'lib')
require 'javaclass/dsl/mixin'

workspace_location = 'C:\RTC3.0\workspaces\Costing_Dev'
package1 = com.ibm.arc.sdm.*
package2 = 'pricingTool'

# 1) create the CompositeClasspath of the given workspace
cp = workspace(workspace_location)

filter = Proc.new { |clazz| clazz.same_or_subpackage_of?(package1) || clazz.same_or_subpackage_of?(package2) }

# 2) load all my classes and mark all their referenced types as accessed
classes = cp.values(&filter)

# 3) mark all their referenced types as accessed
classes.map { |clazz| clazz.imported_types }.flatten.
   find_all(&filter).
   each { |clazz| cp.mark_accessed(clazz) }

# 4) find non accessed ones
unused = cp.names(&filter).
   find_all { |clazz| cp.accessed?(clazz) }
     
puts unused
