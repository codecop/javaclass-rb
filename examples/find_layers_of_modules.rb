# Example usage of dependency graph: Organize the nodes into layers 
# depending on their dependencies. Works with an existing dependency graph, 
# e.g. created by {chart module dependencies example}[link:/files/lib/generated/examples/chart_module_dependencies_txt.html].
# Author::          Peter Kofler
# Copyright::       Copyright (c) 2012, Peter Kofler.
# License::         {BSD License}[link:/files/license_txt.html]
#
# === Steps

#--
# add the lib of this gem to the load path
$:.unshift File.join(File.dirname(__FILE__), '..', 'lib')

#++
require 'javaclass/dependencies/yaml_serializer'

# 1) load dependency graph 
plugins = JavaClass::Dependencies::YamlSerializer.new.load('plugin_dependencies')
components = plugins.to_a

@layerOfComponents = []

# 2) find modules without any dependencies, these are the first/bottom 
first_elements = components.find_all { |c| c.dependencies.size == 0 }.sort
@layerOfComponents << first_elements
components = components - first_elements

def has_all_deps_satisfied?(component)
  already_sorted_dependencies = @layerOfComponents.flatten
  component.dependencies.keys.find { |dependency|
    !already_sorted_dependencies.include?(dependency)
  } == nil
end

while components.size > 0
  cycle = true

  # 3) for each component, check if all dependencies are satisfied combined layers below
  components.each do |component|

    if has_all_deps_satisfied?(component)
      components -= [component]

      # 4) if yes, walk up the dependencies until highest/lowest possible
      index = @layerOfComponents.size - 1
      while (component.dependencies.keys.find { |dependency| @layerOfComponents[index].include?(dependency) } == nil)
        index = index -1
      end
      index = index + 1 # take next

      # and add to the layers
      if index == @layerOfComponents.size
        @layerOfComponents[index] = []
      end
      @layerOfComponents[index] << component

      puts "added #{component}"
      cycle = false
      break
    end

  end
  
  if cycle
    warn "cycle in #{components.join(', ')}, can't continue with layering"
    break
  end
end

# 5) output the found layering
(1..@layerOfComponents.size).each do |i|
  layer = @layerOfComponents[i-1].sort
  puts "#{i} " + layer.join(', ')
end

# TODO separate components not only bz layer, but also be stream
# if it depends only on parent and not on others in the same layer - but a chart would be better for that.
