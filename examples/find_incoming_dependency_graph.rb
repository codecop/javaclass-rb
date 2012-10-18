# Example usage of dependency graph: Invert the graph and see incoming deps.
# TODO desc
# Author::          Peter Kofler
# Copyright::       Copyright (c) 2009, Peter Kofler.
# License::         {BSD License}[link:/files/license_txt.html]
#
# === Steps

#--
# add the lib of this gem to the load path
$:.unshift File.join(File.dirname(__FILE__), '..', 'lib')

location = 'C:\RTC3.0\workspaces\Costing_Dev'

#++
require 'javaclass/dsl/mixin'
require 'javaclass/classpath/tracking_classpath'
require 'javaclass/dependencies/edge'
require 'javaclass/dependencies/yaml_serializer'

# e.g. {xxx}[link:/files/lib/generated/examples/find_unreferenced_classes_txt.html].
cp = classpath(File.join(location, 'com.ibm.arc.sdm.model', 'bin'))
classes = cp.names
# puts "#{classes.size} classes loaded from classpaths"
cp.reset_access

# Load a dependency Graph,
# e.g. created by {chart module dependencies example}[link:/files/lib/generated/examples/chart_module_dependencies_txt.html].
plugins = JavaClass::Dependencies::YamlSerializer.new.load('plugin_dependencies')

def strip(name)
  name.sub(/^com\.ibm\.arc\.sdm\./, '*.')
end

Plugin_name = 'com.ibm.arc.sdm.model'
# Plugin_name = 'PricingTool2'

# A) mark all accessed classes in model plugin 
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

plugins.each_node do |plugin|
  next if plugin.name == Plugin_name
  plugin.each_edge do |dep, edge|
    next unless dep.name == Plugin_name
    puts "#{strip(edge.target)};#{strip(plugin.name)};#{strip(edge.source)}"
  end
end

# ad A) report unused classes in model from outside
unused_classes = classes.find_all { |clazz| cp.accessed(clazz) == 0 }.
    reject { |clazz| clazz =~ /\$.*$/ }
report = unused_classes.map { |clazz| "#{clazz.to_classname}" }.uniq
# puts "#{report.size} private classes found:\n  #{report.join("\n  ")}"
report.each do |clazz|
  puts "#{strip(clazz)};(internal);NA"
end  
