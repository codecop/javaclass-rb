# Example usage of dependency graph: Invert the graph and see incoming deps.
# TODO desc

# Example usage of the class analysis featuress of JavaClass::ClassScanner and JavaClass::Analyse. 
# After defining a classpath, use dependency analysis to find all used classes of a codebase. 
# This code uses in turn the method <i>imported_3rd_party_types</i> of 
# JavaClass::ClassScanner::ImportedTypes to find all imported classes.

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

# 1) create a classpath of the main Eclipse plugin/module(s) under test
cp = classpath(File.join(location, 'com.some.sdm.model', 'bin'))
classes = cp.names
puts "#{classes.count} classes found in main plugin"
cp.reset_access

# 2) load a dependency Graph containing the main module,
# e.g. created by {chart module dependencies example}[link:/files/lib/generated/examples/chart_module_dependencies_txt.html].
plugins = JavaClass::Dependencies::YamlSerializer.new.load('plugin_dependencies')

# strip
def strip(name)
  name.sub(/^com\.some\.sdm\./, '*.')
end

Plugin_name = 'com.some.sdm.model'

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
