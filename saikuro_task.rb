require 'rake'
require 'rake/tasklib'
require 'saikuro'

module Rake

  # Create a task that will generate the Saikuro complexity report for a project.
  # See http://saikuro.rubyforge.org/
  #
  # The SaikuroTask will create the following targets:
  #
  # [<b>:<em>complexity</em></b>]
  #   Main task for this Saikuro task.
  #
  # [<b>:clobber_<em>complexity</em></b>]
  #   Delete all the Saikuro report files.  This target is automatically added to the main clobber target.
  #
  # Simple Saikuro:
  #
  #   Rake::SaikuroTask.new do |rd|
  #     rd.output_dir = 'html'
  #     rd.files.include('lib/**/*.rb')
  #   end
  #
  # The +rd+ object passed to the block is an SaikuroTask object. See the
  # attributes list for the SaikuroTask class for available customization options.
  #
  # Author::          Peter Kofler
  # Copyright::       Copyright (c) 2009, Peter Kofler.       
  # License::         {BSD License}[link:/files/license_txt.html]
  #
  class SaikuroTask < TaskLib
    include Saikuro::ResultIndexGenerator

    # Name of the main, top level task. (default is :complexity)
    attr_accessor :name

    # Name of directory to receive the Saikuro output files. (default is 'complexity')
    attr_accessor :output_dir

    # List of files to be included in the saikuro report. (default is [])
    attr_accessor :files

    # Create the Saikuro tasks with the given base _name_ .
    def initialize(name = :complexity)  # :yield: self
      @name = name
      @files = Rake::FileList.new
      @output_dir = 'complexity'
      @cyclo = true
      @token = false
      
      yield self if block_given?
      
      define_tasks
    end

    private

    # Create the tasks defined by this task lib.
    def define_tasks
      define_clobber_task
      define_build_task
    end
    
    def define_clobber_task
      desc 'Remove Saikuro products'
      task clobber_task_name do
        rm_r @output_dir rescue nil
      end

      task :clobber => [clobber_task_name]
    end

    def define_build_task
      desc "Generate #{build_task_name} report with Saikuro"
      task build_task_name => [clobber_task_name] do
        directory @output_dir
        create_report
      end
    end

    def build_task_name
      name.to_s
    end

    def clobber_task_name
      "clobber_#{name}"
    end

    def create_report
      if @cyclo
        state_filter = Filter.new(5)
        state_formater = Saikuro::StateHTMLComplexityFormater.new(STDOUT, state_filter)
      else
        state_formater = nil
      end
    
      if @token
        token_filter = Filter.new(10, 25, 50)
        token_count_formater = Saikuro::HTMLTokenCounterFormater.new(STDOUT, token_filter)
      else
        token_count_formater = nil
      end

      # ignore DEBUG log in Saikuro
      verbosity = $VERBOSE     
      $VERBOSE = nil
      begin
        idx_states, idx_tokens = Saikuro.analyze(@files, state_formater, token_count_formater, @output_dir)
      ensure
        $VERBOSE = verbosity
      end

      write_cyclo_index(idx_states, @output_dir)
      write_token_index(idx_tokens, @output_dir)
    end

  end
end
