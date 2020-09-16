GEM_NAME = 'javaclass'
GIT_PROJECT = "#{GEM_NAME}-rb"

Gem::Specification.new do |s|
  s.version = '0.4.3'
  s.name = GEM_NAME
  s.rubyforge_project = 'javaclass' if s.respond_to? :rubyforge_project=
  # Gem::Specification#rubyforge_project= is deprecated with no replacement in 2.7
  s.summary = 'Java class files parser and disassembler for Ruby'
  s.description = 'Provides access to the package, protected, and public fields and methods of the classes passed to it together with a list of all outgoing references.'
  s.license = 'BSD-2-Clause'
  s.homepage = "https://github.com/codecop/#{GIT_PROJECT}"
  s.author = 'Peter Kofler'
  s.email = 'peter dot kofler at code minus cop dot org'
  s.date = Time::gm(2020, 9, 16) # set current date for release

  s.files = Dir.glob('*.txt') + Dir.glob('{lib,test,examples}/**/*') + ['javaclass.gemspec', 'Rakefile'] + Dir.glob('rake_*.rb') + Dir.glob('dev/*_task.rb')
  s.test_files = Dir.glob('test/**/test_*.rb')
  s.require_path = 'lib'
  s.add_dependency('rubyzip', '>= 0.9.1')
  s.required_ruby_version = '>= 1.8.6'
  s.required_rubygems_version = nil if s.respond_to? :required_rubygems_version=
  s.platform = Gem::Platform::RUBY
  # s.add_development_dependency('rake', '>= 0.8.3')
  # s.add_development_dependency('rcov', '>= 0.8.1.2')
  # s.add_development_dependency('saikuro', '>= 1.2.1')
  # s.add_development_dependency('ZenTest', '>= 4.4.0')

  s.has_rdoc = true if s.respond_to? :has_rdoc=
  # Gem::Specification#has_rdoc= is deprecated with no replacement in 2.6
  s.extra_rdoc_files = Dir.glob('*.txt')
  s.rdoc_options << '--title' << "#{s.name}-#{s.version} Documentation" <<
                    '--main' << 'Readme.txt'
end
