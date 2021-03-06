# Example usage of JavaClass::Dependencies::Graph: Iterate all folders of a root folder.
# Load each component separately and construct the dependency graph.
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

def relatedPlugin?(name)
  name == 'com.some.pricing' ||
  name == 'org.eclipse.update.scheduler' || # all other org.eclipse, nebula and zentest are in 1st level
  name =~ /^com\.some\./ && !(
    name =~ /gpe\.persistence$/ || # looks like duplicate of rocketdb
    name =~ /\.test$|\.testing$|\.mock$|\.test\.perfmon$/ || # test
    name =~ /\.build/ || # build
    name =~ /rocketDBtools$/ # tools
  )
end
#++
require 'javaclass/dsl/mixin'
require 'javaclass/dependencies/graph'
require 'javaclass/dependencies/classpath_node'
require 'javaclass/dependencies/yaml_serializer'
require 'javaclass/dependencies/graphml_serializer'

# 1) define the location of the plugins
#  location = 'C:\Eclipse\workspace'

plugins = JavaClass::Dependencies::Graph.new

# 2) iterate all plugins of a workspace location
Dir.new(location).each do |folder|
#--
  next unless relatedPlugin?(folder)
#++
  path = File.join(location, folder)
  next unless FileTest.directory? path

  classes = File.join(path, 'bin')
  next unless FileTest.exist?(classes)

# 3) create a classpath for each plugin
  cp = classpath(classes)
  next if cp.count == 0

# 4) add a JavaClass::Dependencies::Node for that plugin to the graph 
  plugins.add(JavaClass::Dependencies::ClasspathNode.new(folder, cp))
end

# 5) resolve all dependencies of all nodes in the graph
plugins.resolve_dependencies
puts "#{plugins.to_a.size} plugins loaded" 

# 6) save the result in various formats, e.g. GraphML or YAML
JavaClass::Dependencies::GraphmlSerializer.new.save('plugin_dependencies', plugins)
JavaClass::Dependencies::YamlSerializer.new.save('plugin_dependencies', plugins)
JavaClass::Dependencies::YamlSerializer.new(:outgoing => :summary).save('plugin_dependencies_summary', plugins)
