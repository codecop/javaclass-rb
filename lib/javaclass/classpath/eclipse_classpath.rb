require 'javaclass/classpath/composite_classpath'

module JavaClass
  module Classpath

    # An Eclipse workspace aware classpath.
    # Author::   Peter Kofler
    class EclipseClasspath < CompositeClasspath

      DOT_CLASSPATH = '.classpath'

      # Check if the _file_ is a valid location for an Eclipse classpath.
      def self.valid_location?(file)
        FileTest.exist?(file) && FileTest.directory?(file) && FileTest.exist?(File.join(file, DOT_CLASSPATH))
      end

      # Add an Eclipse variable _name_ with _value to look up libraries.
      def self.add_variable(name, value)
        @@variables ||= Hash.new
        @@variables[name] = value
      end
      
      # Create a classpath for an Eclipse base project in _folder_ where the .classpath is.
      def initialize(folder)
        raise IOError, "folder #{folder} not an Eclipse project" if !EclipseClasspath::valid_location?(folder)
        super()
        @root = folder
        # kind="output" path="classes"/>
        classpath = IO.readlines(File.join(@root, DOT_CLASSPATH))
        classpath.find_all { |line| line =~ /kind\s*=\s*"output"/ }.each do |line|
          if line =~ /path\s*=\s*"([^"]+)"/
            add_file_name(File.join(@root, $1))
          end
        end

        classpath.find_all { |line| line =~ /kind\s*=\s*"lib"/ }.each do |line|
          if line =~ /path\s*=\s*"([^"]+)"/
            add_file_name(File.join(@root, $1))
          end
        end
        
        @@variables ||= Hash.new
        classpath.find_all { |line| line =~ /kind\s*=\s*"var"/ }.each do |line|
          if line =~ /path\s*=\s*"([^\/]+)\/([^"]+)"/
            path = @@variables[$1]
            add_file_name(File.join(path, $2)) if path
          end
        end
      end

      def to_s
        File.join(@root, DOT_CLASSPATH).to_s
      end

    end

  end
end
