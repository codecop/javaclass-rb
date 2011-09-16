require 'javaclass/classpath/composite_classpath'

module JavaClass
  module Classpath

    # An Eclipse workspace aware classpath.
    # Author::   Peter Kofler
    class EclipseClasspath < CompositeClasspath

      # Check if the _file_ is a valid location for an Eclipse classpath.
      def self.valid_location(file)
        FileTest.exist?(file) && FileTest.directory?(file) && FileTest.exist?(File.join(file, '.classpath'))
      end

      # Create a classpath for an Eclipse base project in _folder_ where the .classpath is.
      def initialize(folder)
        raise IOError, "folder #{folder} not an Eclipse project" if !EclipseClasspath::valid_location(folder)
        super()
        @root = folder
        # kind="output" path="classes"/>
        classpath = IO.readlines(File.join(@root, '.classpath'))
        classpath.find_all { |line| line =~ /kind\s*=\s*"output"/ }.each do |line|
          if line =~ /path="([^"]+)"/
            add_file_name(File.join(@root, $1))
          end
        end
        classpath.find_all { |line| line =~ /kind\s*=\s*"lib"/ }.each do |line|
          if line =~ /path="([^"]+)"/
            add_file_name(File.join(@root, $1))
          end
        end
      end

      def to_s
        @root
      end

    end

  end
end
