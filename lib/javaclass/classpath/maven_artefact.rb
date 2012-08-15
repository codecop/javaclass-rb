require 'javaclass/classpath/composite_classpath'

module JavaClass
  module Classpath

    # A reference to a Maven artefact. This is a group/artefact/version tuple that points to a single Jar in the Maven repository.
    # Author::   Peter Kofler
    class MavenArtefact

      attr_reader :group, :name, :version, :title

      # Create a Maven artefact with given _group_ , _name_ and _version_
      def initialize(group, name, version, title=nil)
        @group = group
        @name = name
        @version = version
        @title = title || make_title
      end

      # Kind of hack function to call Maven to download the current artefact if it does not exist.      
      def download_if_needed
        unless File.exist? repository_path
          puts `#{download_command}`
        end
      end

      # Return this Maven artefact's classpath. This is a single Jar in the Maven repository.
      def classpath
        cp = CompositeClasspath.new(basename)
        cp.add_file_name(repository_path)
        cp
      end
      
      private
      
      def make_title
        @name.sub(/\d$/, '').split(/[\s-]/).map { |p|
          if p.size < 4
            p.upcase
          else
            p.capitalize
          end 
        }.join(' ')
      end

      # Return the Jar's file path of this artefact inside ~/.m2/repository
      def repository_path
        File.join(ENV['HOME'], '.m2', 'repository', @group.gsub(/\./, '/'),  @name, @version, "#{basename}.jar" )
      end
      
      def basename
        "#{@name}-#{@version}"
      end

      def download_command
        "mvn org.apache.maven.plugins:maven-dependency-plugin:2.5:get -Dartifact=#{@group}:#{@name}:#{@version}"
      end

    end

  end
end
