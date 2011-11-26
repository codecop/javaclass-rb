# Example usage of the featuress of JavaClass::Analyse::TransitiveDependencies
# to collect all transitive dependencies of a certain class or a whole package
# (Cumulative Component Dependencies).
# Author::          Peter Kofler
# Copyright::       Copyright (c) 2009, Peter Kofler.       
# License::         {BSD License}[link:/files/license_txt.html]
# See::             Another example how to {list all imported types}[link:/files/lib/generated/examples/find_all_imported_types_txt.html]
#
# === Steps

#--
# add the lib of this gem to the load path
$:.unshift File.join(File.dirname(__FILE__), '..', 'lib')
require File.join(File.dirname(__FILE__), 'corpus')

location = Corpus[:HBD]
package = 'at.herold'
start_class = 'at.herold.waf.hbd.servlet.HBDServlet'
# 'at/spardat/krimiaps/service/client/service/impl/ClientSmeSearchServiceImpl'
# 'at/spardat/krimiaps/service/client/service/impl/ClientPrivateSearchServiceImpl'
#++
require 'javaclass/dsl/mixin'

# 1) create the classpath of the given workspace
cp = workspace(location)
puts "#{cp.count} classes found on classpath"

# define a filter to limit all operations to the classes we are interested in
filter = Proc.new { |classname| classname.same_or_subpackage_of?(package) }

# 2a) collect all transitive dependencies of a single class into an AdderTree 
dependencies = cp.transitive_dependency_tree(start_class.to_javaname, &filter)
puts "#{dependencies.size} classes in transitive dependency graph of class #{start_class}"
dependencies.debug_print

# 2b) or collect all transitive dependencies of a whole package
dependencies = cp.transitive_dependencies_package(start_class.to_javaname.package, &filter)
puts "#{dependencies.size} classes in transitive dependency graph of package"
#  dependencies.debug_print
