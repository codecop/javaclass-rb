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
  s.summary ='A parser and disassembler for Java class files'
  s.files = FileList['Readme.txt', '{lib,test}/**/*.*', 'history.txt', 'planned.txt', 'Rakefile']
  s.test_files = FileList['test/**/test_*.rb']
  s.require_path = 'lib'
  s.has_rdoc = true
  s.rubyforge_project = 'javaclass'
  s.homepage = 'http://code.google.com/p/javaclass-rb/'
  s.author = 'Peter Kofler'
  s.email = 'peter dot kofler at code-cop dot org'
  s.platform = Gem::Platform::RUBY
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
  rdoc.title = "JavaClass #{gemspec.name}-#{gemspec.version} Documentation"
  rdoc.main = gemspec.files.to_a[0]
  rdoc.rdoc_files.include 'Readme.txt', 'lib/**/*.rb', 'history.txt', 'planned.txt'
end

desc 'Remove package and rdoc products'
task :clobber => %w(clobber_package clobber_rdoc)

# Publish an entire directory to an existing remote directory using PuTTY.
class PuttySshDirPublisher < Rake::SshDirPublisher
  def upload
    # call E:\Tool\putty\pscp -r html/* bruno41@rubyforge.org:/var/www/gforge-projects/javaclass
    sh %{E:\\Tool\\PuTTY\\PSCP.EXE -r -q #{@local_dir}/* #{@host}:#{@remote_dir}}
  end
end

desc 'Publish the RDOC files to RubyForge'
task :publish_rdoc => %w(clobber_rdoc rdoc) do
  
  # Save the original robots.txt again
  File.open('./html/robots.txt', 'w') do |f| 
    f.print "User-agent: *
Disallow: /softwaremap/ # This is an infinite virtual URL space
Disallow: /statcvs/ # This is an infinite virtual URL space
Disallow: /usage/ # This is an infinite virtual URL space
Disallow: /wiki/ # This is an infinite virtual URL space
" 
  end
  
  # generic code would be...
  #config = YAML.load(File.read(File.expand_path('~/.rubyforge/user-config.yml')))
  #host = "#{config['username']}@rubyforge.org"
  host = "bruno41@rubyforge.org"
  remote_dir = "/var/www/gforge-projects/#{gemspec.rubyforge_project}/"
  local_dir = 'html'
  
  PuttySshDirPublisher.new(host, remote_dir, local_dir).upload
end

desc 'Package and upload to RubyForge (unfinished)'
task :publish_gem => [:clobber_package, :package] do |t|
  
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
