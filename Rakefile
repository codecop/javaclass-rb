require 'rubygems'

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

desc "Validates the gemspec"
task :gemspec do
  gemspec.validate
end

desc "Displays the current version"
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

desc "Installs the gem locally"
task :install => :package do
  puts `gem install pkg/#{gemspec.name}-#{gemspec.version}`
end

desc "Tag version in Hg and push to origin"
task :tag do
  tag_name = "#{gemspec.name}-#{gemspec.version}"
  puts `hg tag -f -m "Released gem version #{gemspec.version}" #{tag_name}`
  puts `hg push`
end

desc "Release the gem to Rubygems"
task :release_rubygems => :package do
  puts `gem push pkg/#{gemspec.name}-#{gemspec.version}.gem`
end

#* migration rubyforge
#  * http://javaclass.rubyforge.org/ redirecten
#  * neuen Gem releasen
#  * api 0.0.3 uploaden
#  * Deployment von API doc automatisch ins Repo, Redirect updaten

desc 'Package and upload to Rubygems and Google Code (unfinished)'
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

Rake::RDocTask.new do |rdoc|
  # rdoc.rdoc_dir = 'html' is default
  rdoc.title = "#{gemspec.name}-#{gemspec.version} Documentation"
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

desc 'Fix the rdoc HREFs in frameset'
task :rdoc_fix => [:rdoc] do |t|
  Dir['html/**/*.html'].each do |file| 
    next if file =~ /\.src/
    add_href_parent(file) 
  end
end

desc 'Remove package and rdoc products'
task :clobber => [:clobber_package, :clobber_rdoc]

desc 'Publish the RDOC files to Google Code repo (unfinished)'
task :publish_rdoc => [:clobber_rdoc, :rdoc, :rdoc_fix] do
  
  repo = "api.#{s.name}-rb.googlecode.com/hg/"
  remote_dir = "#{gemspec.version}"
  local_dir = 'html'
  
  # add folder if it does not exist
  # update redirect in frameset
  # TODO RDOC - clone, update, commit, push, remove clone
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
