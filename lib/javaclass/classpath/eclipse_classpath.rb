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

      # Skip the lib containers if .classpath.
      def self.skip_lib(flag=true)
        @@skip_lib = flag
      end

      # Create a classpath for an Eclipse base project in _folder_ where the .classpath is.
      def initialize(folder)
        raise IOError, "folder #{folder} not an Eclipse project" if !EclipseClasspath::valid_location?(folder)
        dot_classpath = File.join(folder, DOT_CLASSPATH)
        super(dot_classpath)
        classpath = IO.readlines(dot_classpath)
        
        classpath.find_all { |line| line =~ /kind\s*=\s*"output"/ }.each do |line|
          if line =~ /path\s*=\s*"([^"]+)"/
            add_file_name(File.join(folder, $1))
          end
        end

        classpath.find_all { |line| line =~ /output\s*=\s*"/ }.each do |line|
          if line =~ /output\s*=\s*"([^"]+)"/
            add_file_name(File.join(folder, $1))
          end
        end
        
        @@skip_lib ||= false
        unless @@skip_lib
        
          classpath.find_all { |line| line =~ /kind\s*=\s*"lib"/ }.each do |line|
            if line =~ /path\s*=\s*"([^"]+)"/
              add_file_name(File.join(folder, $1))
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
      
      end

    end

  end
end
