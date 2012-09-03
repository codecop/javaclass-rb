# TODO desc.
# Author::          Peter Kofler
# Copyright::       Copyright (c) 2009, Peter Kofler.
# License::         {BSD License}[link:/files/license_txt.html]
#
# === Steps

#--
# add the lib of this gem to the load path
$:.unshift File.join(File.dirname(__FILE__), '..', 'lib')

location = 'C:\RTC3.0\workspaces\Costing_Dev'

def relatedPlugin?(name)
  name == 'PricingTool2' ||
  name == 'org.eclipse.update.scheduler' ||
  name =~ /^com\.ibm\./ && !(
    name =~ /\.test$|\.testing$|\.mock$|\.test\.perfmon$/ ||
    name =~ /\.build/ ||
    name =~ /rocketDBtools$/ || # tools
    name =~ /\.s2r2\./ ||
    name =~ /gpe\.persistence$/ # looks like duplicate of rocketdb
  )
end
#++
require 'javaclass/dsl/mixin'
require 'javaclass/dependencies/graph'
require 'javaclass/dependencies/classpath_node'
require 'javaclass/dependencies/yaml_serializer'
require 'javaclass/dependencies/graphml_serializer'

plugins = JavaClass::Dependencies::Graph.new

Dir.new(location).each do |folder|
  next unless relatedPlugin?(folder)

  path = File.join(location, folder)
  next unless FileTest.directory? path

  classes = File.join(path, 'bin')
  next unless FileTest.exist?(classes)

  cp = classpath(classes)
  next if cp.count == 0

  puts "#{cp.count} classes found in plugin #{folder}"
  plugins.add(JavaClass::Dependencies::ClasspathNode.new(folder, cp))
end
plugins.resolve_dependencies
puts "#{plugins.to_a.size} plugins loaded" 

JavaClass::Dependencies::GraphmlSerializer.new.save('plugin_dependencies', plugins)
JavaClass::Dependencies::YamlSerializer.new.save('plugin_dependencies', plugins)
