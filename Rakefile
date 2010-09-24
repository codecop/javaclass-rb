#require 'FileUtils'
require 'rubygems'
require 'rubygems/gem_runner' # install and uninstall
require 'rake'
require 'rake/testtask'
require 'rake/gempackagetask'
require 'rake/packagetask'
require 'rake/rdoctask'

# Test, package and publish functions.
# Author::          Peter Kofler

gemspec = Gem::Specification.new do |s|
  s.version = '0.0.3'
  s.name = 'javaclass'
  s.rubyforge_project = 'javaclass' # old, just redirects
  s.summary = 'A parser and disassembler for Java class files'
  s.description = 'Provides access to the package, protected, and public fields and methods of the classes passed to it together with a list of all outgoing references.'
  s.homepage = 'http://code.google.com/p/javaclass-rb/'
  s.author = 'Peter Kofler'
  s.email = 'peter dot kofler at code minus cop dot org'

  s.files = FileList['Readme.txt', '{lib,test}/**/*.*', 'history.txt', 'Rakefile']
  s.test_files = FileList['test/**/test_*.rb']
  s.require_path = 'lib'
  s.add_dependency('rubyzip', '>= 0.9.1') 
  s.required_ruby_version = '>= 1.8.6' 
  s.platform = Gem::Platform::RUBY
  
  s.has_rdoc = true
  s.extra_rdoc_files = ['Readme.txt', 'history.txt']
  s.rdoc_options << '--title' << "#{s.name}-#{s.version} Documentation" <<
                    '--main' << 'Readme.txt' 
end
full_gem_name = "#{gemspec.name}-#{gemspec.version}"

desc 'Validates the gemspec'
task :validate_gem do
  gemspec.validate
end

desc 'Displays the current version'
task :version do
  puts gemspec.version
end

# :test
Rake::TestTask.new do |t| 
  t.test_files = gemspec.test_files
  t.warning = true
  #t.verbose = false is default
end

# :gem
Rake::GemPackageTask.new(gemspec) do |pkg| 
  pkg.need_zip = true
end

# :package, :clobber_package, :repackage
Rake::PackageTask.new(gemspec.name, gemspec.version) do |pkg| 
  #pkg.need_tar = true - no compress in tar on unxutils in Windows
  #pkg.need_tar_gz = true - no compress in tar on unxutils in Windows
  pkg.need_zip = true
  pkg.package_files.include gemspec.files
end

desc 'Install the gem locally'
task :install => :package do
  Gem::GemRunner.new.run ['install', "pkg/#{full_gem_name}"]
end

desc 'Uninstall the gem'
task :uninstall do
  Gem::GemRunner.new.run ['uninstall',  gemspec.name]
end

# Helper method to execute _param_ with Mercurial.
def hg(param)
  puts `hg #{param.join(' ')}`
end

desc 'Tag version in Hg and push to origin'
task :tag do
  hg ['tag', '-f', "-m \"Released gem version #{gemspec.version}\"", "#{full_gem_name}"]
  hg ['push'] 
end

# internal - desc 'Release the gem to Rubygems'
task :release_rubygems => :package do
  puts "Releasing #{full_gem_name} to Rubygems"
  Gem::GemRunner.new.run ['push', "pkg/#{full_gem_name}.gem"]
end

# internal - desc 'Release the gem to Google Code'
task :release_googlecode => :package do
  puts "Releasing #{full_gem_name} to GoogleCode"
  # TODO is this automatable?
  # TODO http://raulraja.com/2009/07/11/script-from-google-code-svn-to-google-code-downloads/
end

desc 'Package and upload gem to Rubygems and Google Code'
task :publish_gem => [:clobber_package, :package, :release_rubygems, :release_googlecode] 

# :rdoc, :clobber_rdoc, :rerdoc
Rake::RDocTask.new do |rdoc|
  # rdoc.rdoc_dir = 'html' is default
  rdoc.title = "#{full_gem_name} Documentation"
  rdoc.main = 'Readme.txt'
  rdoc.rdoc_files.include 'Readme.txt', 'lib/**/*.rb', 'history.txt'
end

# Helper method to add a target="parent" to _file_ html.
def add_href_parent(file)
  lines = IO.readlines(file).collect do |line|
    if line =~ /(href=(?:'|")https?:\/\/)/
      "#{$`}target=\"_parent\" #{$1}#{$'}"
    else 
      line
    end
  end
  File.open(file, 'w') do |f|
    f.print lines.join
  end
end

desc 'Fix the rdoc hrefs in framesets'
task :fix_rdoc => [:rdoc] do |t|
  Dir['html/**/*.html'].each do |file| 
    next if file =~ /\.src/
    add_href_parent(file) 
  end
end

# TODO http://javaclass.rubyforge.org/ redirecten

desc 'Publish the RDOC files to Google Code'
task :publish_rdoc => [:clobber_rdoc, :rdoc, :fix_rdoc] do
  remote_repo = 'api.javaclass-rb.googlecode.com/hg/'
  local_repo = 'api'
  
  # TODO add api to clobber_rdoc
  
  local_dir = 'html'
  remote_dir = "#{gemspec.version}"

  FileUtils.rm_rf local_repo
  hg ['clone', "https://#{remote_repo}", "#{local_repo}"]
  
  FileUtils.cp_r local_dir, "#{local_repo}/#{remote_dir}"
  hg ['addremove', "-R #{local_repo}"]
  # TODO index modifizieren - update redirect in frameset
  hg ['ci', "-m \"Released gem version #{gemspec.version}\"", "-R #{local_repo}"]
  
  #  * api 0.0.3 uploaden
  #  * Deployment von API doc automatisch ins Repo, Redirect updaten
  # TODO RDOC - clone, update, commit, push, remove clone
end

desc 'Remove package and rdoc products'
task :clobber => [:clobber_package, :clobber_rdoc]

# Helper method to grep the sources for some _pattern_ words.
def egrep(pattern)
  Dir['**/*'].find_all {|fn| FileTest.file? fn} .each do |fn|
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
  egrep(/#.*(FI[X]ME|TO[D]O|T[B]D)/) # use 'odd' brackets to not find myself (and not have Eclipse markers)
end

task :default => :test
