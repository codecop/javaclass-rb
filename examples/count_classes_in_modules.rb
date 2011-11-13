# Example usage of classpath: Scan all classpaths (e.g. modules) of an
# Eclipse "workspace" and report the number of classes found there.
# Author::          Peter Kofler

#--
# add the lib of this gem to the load path
$:.unshift File.join(File.dirname(__FILE__), '..', 'lib')
require File.join(File.dirname(__FILE__), 'corpus')

location = Corpus[:HBD]
#++
require 'javaclass/dsl/mixin'

# 1) create a classpath of the workspace
cp = workspace(location)
puts "#{cp.elements.size} classpaths found under the workspace #{location}"

# 2a) find all empty elements
empty = cp.elements.find_all { |clp| clp.count == 0 }
puts "\n#{empty.size} empty modules found:\n  #{empty.join("\n  ")}"

# 2b) or print the list of each element with its class count
puts "library (module path): number of contained classes"
puts cp.elements.map { |clp| [clp.to_s, clp.count] }.
                 sort { |a,b| a[1] <=> b[1] }.
                 map { |e| "  #{e[0]}: #{e[1]}" }
