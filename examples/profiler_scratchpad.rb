# :nodoc:
# Scratchpad script for profiler execution.

require 'ruby-prof'

# add the lib of this gem to the load path
$:.unshift File.join(File.dirname(__FILE__), '..', 'lib')
require 'javaclass/dsl/mixin'
require File.join(File.dirname(__FILE__), 'corpus')

location = File.join(Corpus[:BIA], 'classes')

# 1) create a classpath of the given workspace
#RubyProf.start
cp = classpath(location)
puts "#{cp.elements.size} classpaths found under the workspace #{location}:\n  #{cp.elements.join("\n  ")}"
puts "#{cp.count} classes found in classpaths"
#result = RubyProf.stop

# 2) load all classes
RubyProf.start
cp.values
result = RubyProf.stop

# 3) iterate all constant pool entries
#RubyProf.start
# workspace.external_types
#result = RubyProf.stop

# Print a flat profile to text
printer = RubyProf::GraphPrinter.new(result)
# printer = RubyProf::FlatPrinter.new(result)
printer.print(STDOUT)
