# Advanced example usage of JavaClass::Classpath::TrackingClasspath. Load all 
# classes of an Eclipse workspace. Then mark all referenced classes. In the end 
# report remaining classes as unreferenced. This lists *potential* unused classes. 
# Note that the classes may still be used by reflection. Also this can be used to
# find classes that have a certain number of references to them, e.g. only used once.
# Author::          Peter Kofler
# Copyright::       Copyright (c) 2009, Peter Kofler.
# License::         {BSD License}[link:/files/license_txt.html]
#
# === Steps

#--
# add the lib of this gem to the load path
$:.unshift File.join(File.dirname(__FILE__), '..', 'lib')
require File.join(File.dirname(__FILE__), 'corpus')

location = Corpus[:RCP].location
package1 = 'com.some.sdm'
package2 = 'come.som.more'
#++
require 'javaclass/dsl/mixin'
require 'javaclass/classpath/tracking_classpath'

# speed up loading by skipping non source file classpaths
Eclipse.skip_lib

# 1) create the (tracking) composite classpath of the given workspace
cp = workspace(location)
puts "#{cp.elements.size} classpaths found under the workspace #{location}:"
puts "  #{cp.elements.join("\n  ")}"

# create a filter to limit all operations to the classes of two base packages
filter = Proc.new { |clazz| clazz.same_or_subpackage_of?(package1) || 
                            clazz.same_or_subpackage_of?(package2) }

# 2) load all classes in the given packages
puts 'loading all *filtered* classes... (can take several minutes)'
classes = cp.values(&filter)
puts "#{classes.size} classes loaded from classpaths"

# 3) mark all referenced types in the given packages as accessed
cp.reset_access
classes.map { |clazz| clazz.imported_types }.
        flatten.
        find_all(&filter).
        each { |classname| cp.mark_accessed(classname) }
puts '*filtered* classes mapped'

# 4) also mark all classes referenced from config files (e.g. hardcoded class names)
hardcoded_classnames = scan_config_for_3rd_party_class_names(location).find_all(&filter)
puts "#{hardcoded_classnames.size} classes references found in configs"
hardcoded_classnames.each { |classname| cp.mark_accessed(classname) }
puts 'hardcoded classes mapped'

# 5) mark unit tests (all classes ending in Test) on the test projects (classpath elements ending in .test)
test_projects = cp.elements.find_all { |cpe| cpe.to_s =~ /\.test\// }
test_projects.each do |project|
  project.names { |classname| classname =~ /Test(?:Case|Suite|s)?\.class/ }.
          each { |classname| project.mark_accessed(classname) }
end
puts 'test classes mapped'

# 6) find non accessed classes in specific packages and report them
unused_classes = classes.find_all { |clazz| cp.accessed(clazz) == 0 }
report = unused_classes.map { |clazz| "#{clazz.to_classname}" }
puts "#{report.size} unused classes found:\n  #{report.join("\n  ")}"

# 7) find only once accessed classes and report them
once_used_classes = classes.find_all { |clazz| cp.accessed(clazz) == 1 }
report = once_used_classes.map { |clazz| "#{clazz.to_classname}" }
puts "#{report.size} once used classes found:\n  #{report.join("\n  ")}"

twice_used_classes = classes.find_all { |clazz| cp.accessed(clazz) == 2 }
report = twice_used_classes.map { |clazz| "#{clazz.to_classname}" }
puts "#{report.size} twice used classes found:\n  #{report.join("\n  ")}"
