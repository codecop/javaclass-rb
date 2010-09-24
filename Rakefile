require 'rubygems'

require 'rake'
require 'rake/testtask'
require 'rake/gempackagetask'
require 'rake/packagetask'
require 'rake/rdoctask'
require 'rake/contrib/sshpublisher'

# Test, package and publish functions.
# Author::          Peter Kofler

gemspec = Gem::Specification.new do |s|
  s.version = '0.0.3'
  s.name = 'javaclass'
  s.rubyforge_project = 'javaclass' # old, just redirects
  s.summary ='A parser and disassembler for Java class files'
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

Rake::TestTask.new do |t|
  t.test_files = gemspec.test_files
  t.warning = true
  #t.verbose = false is default
end

Rake::GemPackageTask.new(gemspec) do |pkg|
  pkg.need_zip = true
end

Rake::PackageTask.new(gemspec.name, gemspec.version) do |pkg|
  #pkg.need_tar = true - no compress in tar on unxutils in Windows
  #pkg.need_tar_gz = true - no compress in tar on unxutils in Windows
  pkg.need_zip = true
  pkg.package_files.include gemspec.files
end

Rake::RDocTask.new do |rdoc|
  # rdoc.rdoc_dir = 'html' is default
  rdoc.title = "#{gemspec.name}-#{gemspec.version} Documentation"
  rdoc.main = 'Readme.txt'
  rdoc.rdoc_files.include 'Readme.txt', 'lib/**/*.rb', 'history.txt'
end

desc 'Remove package and rdoc products'
task :clobber => %w(clobber_package clobber_rdoc)

desc 'Publish the RDOC files to Google Code repo (unfinished)'
task :publish_rdoc => %w(clobber_rdoc rdoc) do
  
  repo = "api.#{s.name}-rb.googlecode.com/hg/"
  remote_dir = "#{gemspec.version}"
  local_dir = 'html'
  
  # add folder if it does not exist
  # update redirect in frameset
  # TODO RDOC - clone, update, commit, push, remove clone
end

#* migration rubyforge
#  * http://javaclass.rubyforge.org/ redirecten
#  * target_parent file verschieben ?
#  * Gemcutter Push einrichten im Rake statt Rubyforge
#  * neuen Gem releasen
#  http://www.infoq.com/news/2010/03/rubygems
#  * api 0.0.3 uploaden
#  * Deployment von API doc automatisch ins Repo, Redirect updaten

desc 'Package and upload to Gemcutter and Google Code (unfinished)'
task :publish_gem => [:clobber_package, :package] do |t|
  
  # TODO Release to Gemcutter and Google Code 
  #  rf = RubyForge.new
  #  rf.configure rescue nil
  #  puts 'Logging in'
  #  rf.login
  #  
  #  c = rf.userconfig
  #  c['release_notes'] = PROJ.description if PROJ.description
  #  c['release_changes'] = PROJ.changes if PROJ.changes
  #  c['preformatted'] = true
  
  pkg = "pkg/#{gemspec.full_name}"
  files = Dir.glob("#{pkg}*.*")
  
  puts "Releasing #{gemspec.name} v. #{gemspec.version}"
  #  rf.add_release gemspec.rubyforge_project, gemspec.name, gemspec.version, *files
end

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

desc "Look for TODO and FIXME tags"
task :todo do
  egrep(/#.*(FI[X]ME|TO[D]O|T[B]D)/) # use 'odd' brackets to not find myself (and not have Eclipse markers)
end

task :default => :test
