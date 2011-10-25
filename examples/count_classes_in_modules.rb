# Example usage of classpath: Scan all classes of an Eclipse "workspace" and
# report the number of classes found there.
# Author::          Peter Kofler

# add the lib of this gem to the load path
$:.unshift File.join(File.dirname(__FILE__), '..', 'lib')
require 'javaclass/dsl/mixin'

location = "#{ENV['USERPROFILE']}\\Dropbox\\InArbeit\\Corpus\\Java6_Web(HBD)"

# 1) create a classpath of the workspace
cp = workspace(location)
puts "#{cp.elements.size} classpaths found under the workspace #{location}"

# 2) print the list of classpath elements with class count
puts "library (module path): number of classes"
puts cp.elements.map { |clp| [clp.to_s, clp.count] }.sort { |a,b| a[1] <=> b[1] }.map { |e| "  #{e[0]}: #{e[1]}" }

