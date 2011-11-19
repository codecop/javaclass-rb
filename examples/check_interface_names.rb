# Example usage of classpath and class files: Scan all classes of an workspace.
# Find all interfaces, print their names and find all which are prefixed with 'I'.
# Author::          Peter Kofler
# Copyright::       Copyright (c) 2009, Peter Kofler.       
# License::         {BSD License}[link:/files/license_txt.html]
#
# === Steps

#--
# add the lib of this gem to the load path
$:.unshift File.join(File.dirname(__FILE__), '..', 'lib')
require File.join(File.dirname(__FILE__), 'corpus')

location = Corpus[:Base]
package = 'at.kugel'
#++
require 'javaclass/dsl/mixin'

# 1) define the location of the project and a package you are interrested
#  location = 'C:\Eclipse\workspace'
#  package = 'com.biz.app'

# e.g. add an Eclipse classpath variable to find external dependencies.
Eclipse.add_variable('KOR_HOME', location)

# 2) create the classpath of the given workspace
cp = workspace(location)
puts "#{cp.elements.size} classpaths found under the workspace #{location}:\n  #{cp.elements.join("\n  ")}"
puts "#{cp.count} classes found on classpath"

# 3) filter the classes to analyse
to_analyse = cp.names { |classname| classname.same_or_subpackage_of?(package) }
puts "#{to_analyse.size} classes matched #{package}"

# 4) load and analyse all selected classes, find all interfaces and collect their qualified names
names = cp.values(to_analyse).find_all { |clazz| clazz.interface? }.collect { |clazz| clazz.to_classname }
puts "#{names.size} interfaces found:\n  #{names.sort.join("\n  ")}"

# 5) print all qualified names have a simple namee staring with an I
inames = names.find_all { |classname| classname.simple_name =~ /^I[A-Z][a-z]/ }
puts "#{inames.size} interfaces start with I:\n  #{inames.join("\n  ")}"
