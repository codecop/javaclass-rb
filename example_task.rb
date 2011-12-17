require 'rake'
require 'rake/tasklib'

module Rake

  # Create a documentation task that will generate the example files for a project.
  #
  # The ExampleTask will create the following targets:
  #
  # [<b>:<em>example</em></b>]
  #   Main task for this example task.
  #
  # [<b>:clobber_<em>example</em></b>]
  #   Delete all the example files.  This target is automatically added to the main clobber target.
  #
  # [<b>:re<em>example</em></b>]
  #   Rebuild the example files from scratch, even if they are not out of date.
  #
  # Simple example:
  #
  #   Rake::ExampleTask.new do |rd|
  #     rd.target_dir = 'generated/examples'
  #     rd.example_files.include('examples/**/*.rb')
  #   end
  #
  # The +rd+ object passed to the block is an ExampleTask object. See the
  # attributes list for the ExampleTask class for available customization options.
  #
  # == Specifying different task names
  #
  # You may wish to give the task a different name, such as if you are generating two
  # sets of examples.  For instance, if you want to have a development set of examples:
  #
  #   Rake::ExampleTask.new(:example_dev) do |rd|
  #     rd.example_files.include('dev_examples/**/*.rb')
  #   end
  #
  # The tasks would then be named :<em>example_dev</em>, :clobber_<em>example_dev</em>, and :re<em>example_dev</em>.
  #
  class ExampleTask < TaskLib

    # Name of the main, top level task. (default is :example)
    attr_accessor :name

    # Name of directory to receive the example output files. (default is 'lib/generated/examples')
    attr_accessor :target_dir

    # List of files to be included in the example generation. (default is [])
    attr_accessor :example_files

    # Create the Example tasks with the given base _name_ .
    def initialize(name = :example)  # :yield: self
      @name = name
      @example_files = Rake::FileList.new
      @target_dir = 'lib/generated/examples'
      
      yield self if block_given?
      
      define_tasks
    end

    private

    # Create the tasks defined by this task lib.
    def define_tasks
      define_repeat_task
      define_clobber_task
      define_build_task
    end
    
    def define_repeat_task
      desc 'Force a rebuild of the example files'
      task repeat_task_name => [clobber_task_name, build_task_name]
    end

    def define_clobber_task
      desc 'Remove example products'
      task clobber_task_name do
        rm_r @target_dir rescue nil
      end

      task :clobber => [clobber_task_name]
    end

    def define_build_task
      desc "Build the #{build_task_name} files"
      task build_task_name

      directory @target_dir
      conversion_pairs.each { | a | define_transform(*a) }
    end

    def conversion_pairs
      files_to_convert.map do |example_path|
        [example_path, to_target_file(example_path)]
      end
    end
    public :conversion_pairs
    
    def files_to_convert
      @example_files.find_all { |example_path| convert?(example_path) }
    end

    def define_transform(example_path, example_target)
      task build_task_name => [example_target]
      file example_target => [example_path, Rake.application.rakefile] do
        print '.'
        transform(example_path, example_target)
      end
    end
        
    def build_task_name
      name.to_s
    end

    def clobber_task_name
      "clobber_#{name}"
    end

    def repeat_task_name
      "re#{name}"
    end

    def convert?(text_file)
      IO.readlines(text_file).find { |line| line =~ /# *:nodoc:/ } == nil
    end

    def to_target_file(file)
      target_file = File.basename(file)
      target_file[/\.rb$/] = '.txt'
      File.join(@target_dir, target_file)
    end

    def transform(source, dest)
      input = IO.readlines(source)
      if source =~ /\.rb$/
        lines = commentify(input)
      else
        lines = source
      end
      save(dest, lines)
    end

    def commentify(input)
      lines = []
      input.inject(true) do |add, line|
        if line =~ /^#--/
          false
        elsif line =~ /^#\+\+/
          true
        elsif !add
          false
        elsif line =~ /^#/
          lines << line
          true
        else
          lines << "#  #{line}"
          true
        end
      end
      lines
    end

    def save(name, lines)
      folder = File.dirname(name)
      mkdir_p folder unless File.exist?(folder)
      File.delete name rescue nil
      File.open(name, 'w') { |f| f.print lines.join }
    end

  end
end
