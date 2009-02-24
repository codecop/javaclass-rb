require 'rubygems'

require 'rake'
require 'rake/testtask'
require 'rake/packagetask'
require 'rake/gempackagetask'
require 'rcov/rcovtask'
require 'rake/rdoctask'

gemspec = Gem::Specification.new do |s|
  s.name = 'JavaClass'
  s.version = '0.1'
  s.summary ='TODO'
  s.files = FileList['{lib,test}/**/*.*'] # , 'README.rdoc', 'rakefile.rb']
  s.require_path = 'lib'
  s.has_rdoc = true
  s.rubyforge_project = 'javaclass'
  s.homepage = 'http://javaclass.rubyforge.org/'
  s.author = 'Peter Kofler'
end

Rake::GemPackageTask.new(gemspec) do |pkg|
  pkg.need_tar_gz = true
end

Rake::PackageTask.new(gemspec.name, gemspec.version) do |pkg|
  pkg.need_tar_gz = true
  pkg.package_files.include gemspec.files
end

desc "run unit tests in test/unit"
Rake::TestTask.new "test_units" do |t|
  t.pattern = '**/t[cs]_*.rb'
  t.warning = true
  t.verbose = false
end

desc "Generate documentation"
Rake::RDocTask.new("appdoc") do |rdoc|
  # rdoc.rdoc_dir = 'doc'
  # rdoc.title    = "Kugel's \"Code & Tools Library\" Documentation"
  # rdoc.main     =  'readme.txt'
  # rdoc.options << '--line-numbers'
  # rdoc.options << '--inline-source'
  # rdoc.options << '--charset=utf-8'
  rdoc.rdoc_files.include('lib/**/*.rb') # 'README.rdoc', 
end

task :default => :test_units
