# Scratchpad script for profiler execution.
# Author::          Peter Kofler
require 'ruby-prof'

# add the lib of this gem to the load path
$:.unshift File.join(File.dirname(__FILE__), '..', 'lib')
require 'javaclass/dsl/mixin'

location = "#{ENV['USERPROFILE']}\\Dropbox\\InArbeit\\Corpus\\Java6_Swing(BIA)\\classes"

# 1) create a classpath of the given workspace
cp = classpath(location)
puts "#{cp.elements.size} classpaths found under the workspace #{location}:\n  #{cp.elements.join("\n  ")}"
puts "#{cp.count} classes found in classpaths"

RubyProf.start
# 2) load all classes
cp.values
result = RubyProf.stop

# 3) iterate all constant pool entries
# workspace.external_types

# TODO CONTINUE 6 - improve loading performance, why does it take so long to load 10.000 headers?

# Print a flat profile to text
printer = RubyProf::GraphPrinter.new(result)
# printer = RubyProf::FlatPrinter.new(result)
printer.print(STDOUT)
