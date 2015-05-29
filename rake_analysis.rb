require 'rake'
require 'rake/clean' # for clean/clobber

# Static analysis functions.
# Author::           Peter Kofler

gemspec = eval(IO.readlines('javaclass.gemspec').join)

begin
  require File.dirname(__FILE__) + '/dev/saikuro_task'

# :complexity, :clobber_complexity, :recomplexity
Rake::SaikuroTask.new do |saikuro|
  saikuro.files.include "#{gemspec.require_path}/**/*.rb"
end

rescue LoadError
  # skip if not installed
  warn("saikuro not installed. complexity not available. #{$!}")
end

# Helper method to grep all the sources for some _pattern_ words.
def egrep(pattern)
  Dir['**/*'].
    find_all { |fn| FileTest.file?(fn) }.
    reject { |fn| File.basename(fn) =~ /^\./ }.
    reject { |fn| fn =~ /^hosting\// }.
    each do |fn|
      line_count = 0
      open(fn) do |f|
        while line = f.gets
          line_count += 1
          if line =~ pattern
            puts "#{fn}:#{line_count}:#{line.strip}"
          end
        end
      end
    end
end

desc 'Look for TODO and FIXME tags'
task :todo do
  egrep(/#.*(FI[X]ME|TO[D]O|T[B]D|H[A]CK)/i) # use 'odd' brackets to not find myself (and not have Eclipse markers)
end

task :default => :complexity
