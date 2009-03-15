require 'rubygems'

require 'rake'
require 'rake/testtask'
require 'rake/packagetask'
require 'rake/gempackagetask'
require 'rake/rdoctask'

jcversion = '0.0.1'

gemspec = Gem::Specification.new do |s|
  s.name = 'javaclass'
  s.version = jcversion
  s.summary ='A parser and disassembler for Java class files'
  s.files = FileList['Readme.txt', 'History.txt', '{lib,test}/**/*.*' , 'Rakefile']
  s.test_files = FileList["{test}/**/test_*.rb"]
  s.require_path = 'lib'
  s.has_rdoc = true
  s.rubyforge_project = 'javaclass'
  s.homepage = 'http://javaclass.rubyforge.org/'
  s.author = 'Peter Kofler'
  s.email = 'bruno41 at rubyforge dot org'
  s.platform = Gem::Platform::RUBY
  # TODO Gem::manage_gems is deprecated and will be removed on or after March 2009.
end

Rake::GemPackageTask.new(gemspec) do |pkg|
  pkg.need_tar = true
end

Rake::PackageTask.new(gemspec.name, gemspec.version) do |pkg|
  pkg.need_tar = true
  pkg.package_files.include gemspec.files
end

Rake::TestTask.new do |t|
  t.pattern = 'test/**/test_*.rb'
  t.warning = true
  t.verbose = false
end

Rake::RDocTask.new do |rdoc|
  # rdoc.rdoc_dir = 'html'
  rdoc.title    = "JavaClass javaclass-#{jcversion} Documentation"
  rdoc.main     = 'Readme.txt'
  rdoc.rdoc_files.include 'Readme.txt', 'History.txt', 'lib/**/*.rb'
end

task :default => :test
