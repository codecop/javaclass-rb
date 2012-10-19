require 'rake'
require 'rake/clean' # for clean/clobber
require File.dirname(__FILE__) + '/saikuro_task'

# Static analysis functions.
# Author::           Peter Kofler

gemspec = eval(IO.readlines('javaclass.gemspec').join)

# :complexity, :clobber_complexity, :recomplexity
Rake::SaikuroTask.new do |saikuro|
  saikuro.files.include "#{gemspec.require_path}/**/*.rb"
end

# Helper method to grep all the sources for some _pattern_ words.
def egrep(pattern)
  Dir['**/*'].find_all { |fn| FileTest.file?(fn) && File.basename(fn) != /^\./ }.each do |fn|
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
