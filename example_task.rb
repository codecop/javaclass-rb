#!/usr/bin/env ruby

require 'rake'
require 'rake/tasklib'

module Rake

  # Create a documentation task that will generate the RDoc files for
  # a project.
  #
  # The ExampleTask will create the following targets:
  #
  # [<b>:<em>example</em></b>]
  #   Main task for this RDOC task.  
  #
  # [<b>:clobber_<em>example</em></b>]
  #   Delete all the example files.  This target is automatically
  #   added to the main clobber target.
  #
  # [<b>:re<em>example</em></b>]
  #   Rebuild the rdoc files from scratch, even if they are not out
  #   of date.
  #
  # Simple example:
  #
  #   Rake::ExampleTask.new do |rd|
  #     rd.main = "README.rdoc"
  #     rd.example_files.include("README.rdoc", "lib/**/*.rb")
  #   end
  #
  # The +rd+ object passed to the block is an ExampleTask object. See the
  # attributes list for the ExampleTask class for available customization options.
  #
  # == Specifying different task names
  #
  # You may wish to give the task a different name, such as if you are
  # generating two sets of documentation.  For instance, if you want to have a
  # development set of documentation including private methods:
  #
  #   Rake::ExampleTask.new(:example_dev) do |rd|
  #     rd.main = "README.doc"
  #     rd.example_files.include("README.rdoc", "lib/**/*.rb")
  #     rd.options << "--all"
  #   end
  #
  # The tasks would then be named :<em>example_dev</em>, :clobber_<em>example_dev</em>, and
  # :re<em>example_dev</em>. 
  #
  # If you wish to have completely different task names, then pass a Hash as
  # first argument. With the <tt>:example</tt>, <tt>:clobber_example</tt> and
  # <tt>:reexample</tt> options, you can customize the task names to your liking.
  # For example:
  #
  #   Rake::ExampleTask.new(:example => "example", :clobber_example => "example:clean", :reexample => "example:force")
  #
  # This will create the tasks <tt>:example</tt>, <tt>:example_clean</tt> and
  # <tt>:example:force</tt>.
  #
  class ExampleTask < TaskLib
    # Name of the main, top level task.  (default is :example)
    attr_accessor :name

    # Name of directory to receive the html output files. (default is "html")
    attr_accessor :example_dir

    # Title of Example documentation. (defaults to rdoc's default)
    attr_accessor :title

    # Name of file to be used as the main, top level file of the
    # Example. (default is none)
    attr_accessor :main

    # Name of template to be used by rdoc. (defaults to rdoc's default)
    attr_accessor :template

    # List of files to be included in the example generation. (default is [])
    attr_accessor :example_files

    # Additional list of options to be passed example.  (default is [])
    attr_accessor :options

    # Whether to run the example process as an external shell (default is false)
    attr_accessor :external
    
    attr_accessor :inline_source

    # Create an Example task with the given name. See the ExampleTask class overview
    # for documentation.
    def initialize(name = :example)  # :yield: self
      if name.is_a?(Hash)
        invalid_options = name.keys.map { |k| k.to_sym } - [:example, :clobber_example, :reexample]
        if !invalid_options.empty?
          raise ArgumentError, "Invalid option(s) passed to ExampleTask.new: #{invalid_options.join(", ")}"
        end
      end
      
      @name = name
      @example_files = Rake::FileList.new
      @example_dir = 'html'
      @main = nil
      @title = nil
      @template = nil
      @external = false
      @inline_source = true
      @options = []
      yield self if block_given?
      define
    end
    
    # Create the tasks defined by this task lib.
    def define
      if example_task_name != "example"
        desc "Build the RDOC HTML Files"
      else
        desc "Build the #{example_task_name} HTML Files"
      end
      task example_task_name
      
      desc "Force a rebuild of the RDOC files"
      task reexample_task_name => [clobber_task_name, example_task_name]
      
      desc "Remove example products" 
      task clobber_task_name do
        rm_r example_dir rescue nil
      end
      
      task :clobber => [clobber_task_name]
      
      directory @example_dir
      task example_task_name => [example_target]
      file example_target => @example_files + [Rake.application.rakefile] do
        rm_r @example_dir rescue nil
        @before_running_example.call if @before_running_example
        args = option_list + @example_files
        if @external
          argstring = args.join(' ')
          sh %{ruby -Ivendor vender/rd #{argstring}}
        else
          require 'rdoc/rdoc'
          RDoc::RDoc.new.document(args)
        end
      end
      self
    end

    def option_list
      result = @options.dup
      result << "-o" << @example_dir
      result << "--main" << quote(main) if main
      result << "--title" << quote(title) if title
      result << "-T" << quote(template) if template
      result << "--inline-source" if inline_source && !@options.include?("--inline-source") && !@options.include?("-S")
      result
    end

    def quote(str)
      if @external
        "'#{str}'"
      else
        str
      end
    end

    def option_string
      option_list.join(' ')
    end
    
    # The block passed to this method will be called just before running the
    # RDoc generator. It is allowed to modify ExampleTask attributes inside the
    # block.
    def before_running_example(&block)
      @before_running_example = block
    end

    private
    
    def example_target
      "#{example_dir}/index.html"
    end
    
    def example_task_name
      case name
      when Hash
        (name[:example] || "example").to_s
      else
        name.to_s
      end
    end
    
    def clobber_task_name
      case name
      when Hash
        (name[:clobber_example] || "clobber_example").to_s
      else
        "clobber_#{name}"
      end
    end
    
    def reexample_task_name
      case name
      when Hash
        (name[:reexample] || "reexample").to_s
      else
        "re#{name}"
      end
    end

  end
end
