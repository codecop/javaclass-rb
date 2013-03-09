# Example usage of JavaClass::Dependencies::Graph: Iterate all classes of a 
# classpath and construct the Java dependency graph.
# Author::          Peter Kofler
# Copyright::       Copyright (c) 2009, Peter Kofler.
# License::         {BSD License}[link:/files/license_txt.html]
#
# === Steps

#--
# add the lib of this gem to the load path
$:.unshift File.join(File.dirname(__FILE__), '..', 'lib')
require File.join(File.dirname(__FILE__), 'corpus')

corpus = Corpus[:WF]
location = corpus.location
#++
require 'javaclass/dsl/mixin'
require 'javaclass/dependencies/graph'
require 'javaclass/dependencies/class_node'
require 'javaclass/dependencies/yaml_serializer'
require 'javaclass/dependencies/graphml_serializer'

# 1) create the classpath of a given location
cp = classpath(location)

dependencies = JavaClass::Dependencies::Graph.new

# 2) iterate all classes of the classpath
cp.values.each do |clazz|
  next unless clazz.access_flags.public?

# 3) add a JavaClass::Dependencies::ClassNode for each class to the graph 
  dependencies.add(JavaClass::Dependencies::ClassNode.new(clazz))
end

# 4) resolve all dependencies of all nodes in the graph. Now each class (Node) has a dependency to
# all imported classes (Nodes).
dependencies.resolve_dependencies
puts "#{dependencies.to_a.size} classes loaded" 

# 5) save the result in various formats, e.g. GraphML or YAML, skipping outgoing edges information
JavaClass::Dependencies::GraphmlSerializer.new(:edges => :no_text).save('class_dependencies', dependencies)
JavaClass::Dependencies::YamlSerializer.new(:outgoing => :none).save('class_dependencies', dependencies)
