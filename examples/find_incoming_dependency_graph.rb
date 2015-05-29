# Example usage of dependency graph: Invert the graph and see incoming dependencies of a module.
# After getting all classes of a module, use previously generated dependency graph to iterate 
# all incoming edges. Then either report all incoming edges as CSV or find all private/inner
# classes of the module.
# Author::          Peter Kofler
# Copyright::       Copyright (c) 2012, Peter Kofler.
# License::         {BSD License}[link:/files/license_txt.html]
#
# === Steps

#--
# add the lib of this gem to the load path
$:.unshift File.join(File.dirname(__FILE__), '..', 'lib')
require File.join(File.dirname(__FILE__), 'corpus')

corpus = Corpus[:RCP]
location = corpus.location
#++
require 'javaclass/dsl/mixin'
require 'javaclass/classpath/tracking_classpath'
require 'javaclass/dependencies/edge'
require 'javaclass/dependencies/yaml_serializer'

# 1) create a classpath of the main model  plugin
Plugin_name = 'com.some.sdm.model'
cp = classpath(File.join(location, Plugin_name, 'bin'))
classes = cp.names
puts "#{classes.count} classes found in main plugin"
cp.reset_access

# 2) load a dependency Graph containing the model
# e.g. created by {chart module dependencies example}[link:/files/lib/generated/examples/chart_module_dependencies_txt.html].
plugins = JavaClass::Dependencies::YamlSerializer.new.load('plugin_dependencies')

# used to strip beginning of full qualified names
def strip(name)
  name.sub(/^com\.some\.sdm\./, '*.')
end

# 3) mark all accessed classes in model plugin using the dependency graph
plugins.each_node do |plugin|
  next if plugin.name == Plugin_name
  plugin.each_edge do |dep, edge|
    next unless dep.name == Plugin_name
    cp.mark_accessed(edge.target)
  end
end

plugins.each_node do |plugin|
  plugin.each_dependency_provider do |dep, dependencies|
    plugin.dependencies[dep] = dependencies.map { |edge| 
      # replace class edges by package edges
      # JavaClass::Dependencies::Edge.new(edge.source.to_javaname.package, edge.target.to_javaname.package)

      # replace class edges with source plugin, target package
      # JavaClass::Dependencies::Edge.new(plugin.name, edge.target.to_javaname.package)

      # replace source edges with source plugin
      JavaClass::Dependencies::Edge.new(plugin.name, edge.target)
    }.uniq.sort
  end
end

# 4) report all incoming dependencies (edges) for further Excel analysis 
plugins.each_node do |plugin|
  next if plugin.name == Plugin_name
  plugin.each_edge do |dep, edge|
    next unless dep.name == Plugin_name
    puts "#{strip(edge.target)};#{strip(plugin.name)};#{strip(edge.source)}"
  end
end

# 5) report unused classes in model from outside
unused_classes = classes.
    find_all { |clazz| cp.accessed(clazz) == 0 }.
    reject { |clazz| clazz =~ /\$.*$/ }
report = unused_classes.map { |clazz| "#{clazz.to_classname}" }.uniq
puts "#{report.size} private classes found:"
report.each do |clazz|
  puts "#{strip(clazz)};(internal);NA"
end  
