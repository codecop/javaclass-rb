# Example usage of transitive dependencies to get an idea about  Cumulative Component Dependencies.
# Author::          Peter Kofler

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

# 1) create the (tracking) CompositeClasspath of the given workspace
cp = workspace(location)
puts "#{cp.count} classes found on classpath"

# limit all operations to the classes we are interrested in
filter = Proc.new { |classname| classname.same_or_subpackage_of?(package) }

# 2a) collect all transitive dependencies from its package
dependencies = cp.transitive_dependencies_package(start_class.to_javaname.package, &filter)
puts "#{dependencies.size} classes in transitive dependency graph of package"
# dependencies.debug_print

# 2b) or collect all transitive dependencies from a single class
dependencies = cp.transitive_dependency_tree(start_class.to_javaname, &filter)
puts "#{dependencies.size} classes in transitive dependency graph of class"
dependencies.debug_print
