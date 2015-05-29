GEM_NAME = 'javaclass'
HG_PROJECT = "#{GEM_NAME}-rb"

Gem::Specification.new do |s|
  s.version = '0.4.1'
  s.name = GEM_NAME
  s.rubyforge_project = 'javaclass' # old, just redirects
  s.summary = 'Java class files parser and disassembler for Ruby'
  s.description = 'Provides access to the package, protected, and public fields and methods of the classes passed to it together with a list of all outgoing references.'
  s.license = 'BSD'
  s.homepage = "https://bitbucket.org/pkofler/#{HG_PROJECT}"
  s.author = 'Peter Kofler'
  s.email = 'peter dot kofler at code minus cop dot org'
  s.date = Time::gm(2015, 5, 30) # set current date for release

  s.files = Dir.glob('*.txt') + Dir.glob('{lib,test,examples}/**/*') + ['javaclass.gemspec', 'Rakefile'] + Dir.glob('rake_*.rb') + Dir.glob('dev/*_task.rb')
  s.test_files = Dir.glob('test/**/test_*.rb')
  s.require_path = 'lib'
  s.add_dependency('rubyzip', '>= 0.9.1')
  s.required_ruby_version = '>= 1.8.6'
  s.required_rubygems_version = nil if s.respond_to? :required_rubygems_version=
  s.platform = Gem::Platform::RUBY
  s.add_development_dependency('rake', '>= 0.8.3')
  # s.add_development_dependency('rcov', '>= 0.8.1.2')
  # s.add_development_dependency('saikuro', '>= 1.2.1')
  # s.add_development_dependency('ZenTest', '>= 4.4.0')

  s.has_rdoc = true
  s.extra_rdoc_files = Dir.glob('*.txt')
  s.rdoc_options << '--title' << "#{s.name}-#{s.version} Documentation" <<
                    '--main' << 'Readme.txt'
end
