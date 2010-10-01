#require 'FileUtils' # already required
require 'net/http'
require 'rubygems'
require 'rubygems/gem_runner' # install and uninstall
require 'rake'
require 'rake/clean' # for clean/clobber
require 'rake/testtask'
require 'rake/gempackagetask'
require 'rake/packagetask'
require 'rake/rdoctask'

# Test, package and publish functions.
# Author::          Peter Kofler
# See: http://rake.rubyforge.org/files/doc/rakefile_rdoc.html
GEM_NAME = 'javaclass'
GOOGLE_PROJECT = "#{GEM_NAME}-rb"
RDOC_DIR = 'html'
RDOC_REPO = 'api'

gemspec = Gem::Specification.new do |s|
  s.version = '0.0.3'
  s.name = GEM_NAME
  s.rubyforge_project = 'javaclass' # old, just redirects
  s.summary = 'A parser and disassembler for Java class files'
  s.description = 'Provides access to the package, protected, and public fields and methods of the classes passed to it together with a list of all outgoing references.'
  s.homepage = "http://code.google.com/p/#{GOOGLE_PROJECT}/"
  s.author = 'Peter Kofler'
  s.email = 'peter dot kofler at code minus cop dot org'
  
  s.files = FileList['Readme.txt', '{lib,test,examples}/**/*.*', 'history.txt', 'Rakefile']
  s.test_files = FileList['test/**/test_*.rb']
  s.require_path = 'lib'
  s.add_dependency('rubyzip', '>= 0.9.1')
  s.required_ruby_version = '>= 1.8.6' 
  s.platform = Gem::Platform::RUBY
  s.add_development_dependency('rake', '>= 0.8.4')
  s.add_development_dependency('ZenTest', '>= 4.4.0')
  
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

desc 'Find missing test methods with ZenTest'
task :zentest do
  files = gemspec.files.find_all { |f| f =~ /^#{gemspec.require_path}.*\.rb$/ } + gemspec.test_files
  output = `ruby -I#{gemspec.require_path} -e "require 'rubygems'; load(Gem.bin_path('ZenTest', 'zentest'))" #{files.join(' ')}`
  puts output.gsub(/^#.*\n/, '') # skip all ZenTest comments
end

desc 'Run Autotest'
task :autotest do
  `ruby -e "require 'rubygems'; load(Gem.bin_path('ZenTest', 'autotest'))"`
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
task :install_gem => :package do
  Gem::GemRunner.new.run ['install', "pkg/#{full_gem_name}"]
end

desc 'Uninstall the gem'
task :uninstall_gem do
  Gem::GemRunner.new.run ['uninstall', gemspec.name]
end

# Helper method to execute Mercurial with the _params_ array.
# The +hg+ executable must be in the path.
def hg(params)
  puts `hg #{params.join(' ')}`
end

desc 'Tag current version in Hg'
task :tag do
  hg ['tag', '-f', "-m \"Released gem version #{gemspec.version}\"", "#{full_gem_name}"]
  puts 'Tag created. Don\'t forget to push'
end

# internal - desc 'Release the gem to Rubygems'
task :release_rubygems => :package do
  puts "Releasing #{full_gem_name} to Rubygems"
  Gem::GemRunner.new.run ['push', "pkg/#{full_gem_name}.gem"]
end

# Read username and password from the <code>~/.hgrc</code> for _authname_ prefix.
# <code>HOME</code> environment must be set.
def user_pass_from_hgrc(authname)
  lines = IO.readlines(File.expand_path('~/.hgrc'))
  user = lines.find{ |l| l =~ /#{authname}.username/ }[/[^\s=]+$/] 
  raise "could not find key #{authname}.username in ~/.hgrc" unless user
  pass = lines.find{ |l| l =~ /#{authname}.password/ }[/[^\s=]+$/]
  raise "could not find key #{authname}.password in ~/.hgrc" unless pass
  [user, pass] 
end

# Download the <code>googlecode_upload.py</code> from Google Code repository and save it as _name_ .
# See:: http://support.googlecode.com/svn/trunk/scripts/googlecode_upload.py
def download_googlecode_upload_py(name)
  Net::HTTP.start('support.googlecode.com', 80) do |http|
    body = http.get("/svn/trunk/scripts/#{name}").body
    File.open(name, 'w') { |f| f.print body }
  end
end

# Helper method to execute Python with the _params_ array.
# The +python+ executable must be in the path.
def python(params)
  puts "python #{params.join(' ')}"
  # TODO puts `python #{params.join(' ')}`
end

# internal - desc 'Release the gem to Google Code'
#task :release_googlecode => :package do
desc 'Testing'
task :release_googlecode do
  puts "Releasing #{full_gem_name} to GoogleCode"
  user, pass = user_pass_from_hgrc(gemspec.name)
  # See:: http://code.google.com/p/support/wiki/ScriptedUploads
  download_googlecode_upload_py 'googlecode_upload.py'
  ['gem', 'zip'].each do |extension|
    puts "uploading \"pkg/#{full_gem_name}.#{extension}\"..."
    python ['googlecode_upload.py', "-s \"JavaClass #{gemspec.version} #{extension.capitalize}\"", "-p #{GOOGLE_PROJECT}", "-u #{user}", "-w #{pass}", "pkg/#{full_gem_name}.#{extension}"]
  end
end

desc 'Package and upload gem to Rubygems and Google Code'
task :publish_gem => [:clobber_package, :gem, :package, :release_rubygems, :release_googlecode] 

# :rdoc, :clobber_rdoc, :rerdoc
Rake::RDocTask.new do |rdoc|
  rdoc.rdoc_dir = RDOC_DIR # 'html' is default anyway
  rdoc.title = "#{full_gem_name} Documentation"
  rdoc.main = 'Readme.txt'
  rdoc.rdoc_files.include 'Readme.txt', 'lib/**/*.rb', 'history.txt'
end

# Helper method to add target="_parent" to all external links in _file_ html.
def add_href_parent(file)
  lines = IO.readlines(file).collect do |line|
    if line =~ /(href=(?:'|")https?:\/\/)/
      "#{$`}target=\"_parent\" #{$1}#{$'}"
    else 
      line
    end
  end
  File.open(file, 'w') { |f| f.print lines.join }
end

desc 'Fix the RDoc hrefs in framesets'
task :fix_rdoc => [:rdoc] do 
  Dir["#{RDOC_DIR}/**/*.html"].each { |file| add_href_parent(file) } 
end

# Helper method to add the gem version _dir_ into index _file_ to frameset links.
def add_frameset_version(file, dir)
  lines = IO.readlines(file).collect do |line|
    if line =~ /(frame src=")/
      "#{$`}#{$1}#{dir}/#{$'}"
    else 
      line
    end
  end
  File.open(file, 'w') { |f| f.print lines.join }
end

desc 'Publish the RDoc files to Google Code and push to origin'
task :publish_rdoc => [:clobber_rdoc, :rdoc, :fix_rdoc] do 
  puts "Releasing #{full_gem_name} to API"

  remote_repo = "https://#{RDOC_REPO}.#{GOOGLE_PROJECT}.googlecode.com/hg/"
  remote_dir = "#{gemspec.version}"
  
  FileUtils.rm_r RDOC_REPO rescue nil
  hg ['clone', remote_repo, RDOC_REPO]
  
  FileUtils.rm_r "#{RDOC_REPO}/#{remote_dir}" rescue nil
  FileUtils.cp_r RDOC_DIR, "#{RDOC_REPO}/#{remote_dir}"
  
  # modify index, update redirect in frameset
  file = "#{RDOC_REPO}/index.html"
  FileUtils.cp "#{RDOC_REPO}/#{remote_dir}/index.html", file
  add_frameset_version(file, remote_dir)
  
  hg ['addremove', '-q', "-R #{RDOC_REPO}"]
  hg ['ci', "-m \"Released gem version #{gemspec.version}\"", "-R #{RDOC_REPO}"]
  hg ['tag', '-f', "-m \"Released gem version #{gemspec.version}\"", "-R #{RDOC_REPO}", "#{full_gem_name}"]
  # hg ['push', "-R #{RDOC_REPO}"]
end

# :clean :clobber 
CLOBBER.include(RDOC_REPO, 'googlecode_upload.py')

# Helper method to grep all the sources for some _pattern_ words.
def egrep(pattern)
  Dir['**/*'].find_all { |fn| FileTest.file? fn }.each do |fn|
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

task :default => :test
