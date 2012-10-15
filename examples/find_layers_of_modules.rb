# Example usage of dependency graph: Organize the nodes into layers 
# depending on their dependencies.
# Author::          Peter Kofler
# Copyright::       Copyright (c) 2009, Peter Kofler.
# License::         {BSD License}[link:/files/license_txt.html]
#
# === Steps

#--
# add the lib of this gem to the load path
$:.unshift File.join(File.dirname(__FILE__), '..', 'lib')

#++
require 'javaclass/dependencies/yaml_serializer'

# Load a dependency Graph, 
# e.g. created by {chart module dependencies example}[link:/files/lib/generated/examples/chart_module_dependencies_txt.html].
plugins = JavaClass::Dependencies::YamlSerializer.new.load('plugin_dependencies')
components = plugins.to_a

first_elements = components.find_all { |c| c.dependencies.size == 0 }.sort

@list = []
@list << first_elements
components = components - first_elements

def has_all_deps_in_list(component)
  already_sorted_dependencies = @list.flatten
  # puts "testing #{component}"
  component.dependencies.keys.find { |dependency|
    !already_sorted_dependencies.include?(dependency)
  } == nil
end

while components.size > 0

  components.each do |component|

    if has_all_deps_in_list(component)
      components -= [component]

      index = @list.size - 1
      while (component.dependencies.keys.find { |dependency| @list[index].include?(dependency) } == nil)
        index = index -1
      end
      index = index + 1 # take next
      if index == @list.size
        @list[index] = []
      end
      @list[index] << component

      puts "added #{component}"
      break
    end

  end

end

(1..@list.size).each do |i|
  layer = @list[i-1]
  puts "#{i} " + layer.join(', ')
end

# TODO add more, separate the streams, not just the layers, 
# so if it depends only on parent and not on others there.
# but chart would be better.
