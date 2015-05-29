# Example usage of JavaClass::Classpath and JavaClass::Classpath::TrackingClasspath: 
# Use the classes of one module and mark all their dependencies. Then find all modules 
# which were not referenced. This list contains *potential* unused libraries (modules). 
# Note that the libraries may still be used by reflection or internal from other libraries.
# Author::          Peter Kofler
# Copyright::       Copyright (c) 2009, Peter Kofler.
# License::         {BSD License}[link:/files/license_txt.html]
#
# === Steps

#--
# add the lib of this gem to the load path
$:.unshift File.join(File.dirname(__FILE__), '..', 'lib')
require File.join(File.dirname(__FILE__), 'corpus')

corpus = Corpus[:BIA]
location = corpus.location
main_location = corpus.classes
test_location = corpus.testClasses
#++
require 'javaclass/dsl/mixin'

# 1) create a classpath of the main module(s) under test
main_classpath = classpath("#{main_location};#{test_location}")
puts "#{main_classpath.count} classes found in main classpath:"
puts "  #{main_classpath.elements.join("\n  ")}"

# 2) mix in JavaClass::Classpath::TrackingClasspath before creating any new classpaths
require 'javaclass/classpath/tracking_classpath'

# 3) create the (tracking) composite classpath of the given workspace
cp = workspace(location)
puts "#{cp.elements.size} classpaths found under the workspace #{location}"
puts "  #{cp.elements.join("\n  ")}"
puts "#{cp.count} classes found in classpaths"

# 4) mark all their referenced types as accessed in the workspace
puts 'mapping referenced classes... (can take several minutes)'
cp.reset_access
main_classpath.external_types.each { |clazz| cp.mark_accessed(clazz) }
puts 'referenced classes mapped'

# 5a) now find non accessed modules/libraries (i.e. classpath elements)
unused = cp.elements.find_all { |clp| clp.jar? && clp.accessed == 0 }
puts "\n#{unused.size} unused modules found:\n  #{unused.join("\n  ")}"

# 5b) or print the list of classpath elements (e.g. JARs) with their access
puts "\nlibrary (module path): number of accessed classes"
puts cp.elements.map { |clp| [clp.to_s, clp.accessed] }.
                 sort { |a,b| a[1] <=> b[1] }.
                 map { |e| "  #{e[0]}: #{e[1]}" }
