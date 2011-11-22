# Example usage of classpath (JavaClass::Classpath): Scan all classpaths (e.g. modules)
# of an an Eclipse "workspace". A workspace is a folder containing several Eclipse
# projects, e.g. JavaClass::Classpath::EclipseClasspath. Report the number of found
# classes per module.
# Author::          Peter Kofler
# Copyright::       Copyright (c) 2009, Peter Kofler.       
# License::         {BSD License}[link:/files/license_txt.html]
#
# === Steps

#--
# add the lib of this gem to the load path
$:.unshift File.join(File.dirname(__FILE__), '..', 'lib')
require File.join(File.dirname(__FILE__), 'corpus')

location = Corpus[:HBD]
#++
require 'javaclass/classpath/factory'
include JavaClass::Classpath::Factory
# The require/include above just imports what is needed, but usually one would require the whole 
# JavaClass::Dsl::Mixin for conveniance, e.g. require 'javaclass/dsl/mixin'. 

# 1) define the location of the project
#  location = 'C:\Eclipse\workspace'

# 2) create a JavaClass::Classpath::CompositeClasspath of the complete workspace, which will contain many classpath elements.
cp = workspace(location)
puts "#{cp.elements.size} classpaths found under the workspace #{location}"

# 3a) find all empty elements by querying the classpath elements
empty = cp.elements.find_all { |clp| clp.count == 0 }
puts "\n#{empty.size} empty modules found:\n  #{empty.join("\n  ")}"

# 3b) or print the list of each element with its class count
puts "library (module path): number of contained classes"
puts cp.elements.map { |clp| [clp.to_s, clp.count] }.
                 sort { |a,b| a[1] <=> b[1] }.
                 map { |e| "  #{e[0]}: #{e[1]}" }
