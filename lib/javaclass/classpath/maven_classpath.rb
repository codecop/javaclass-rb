require 'javaclass/classpath/composite_classpath'

module JavaClass
  module Classpath
    
    # A Maven folder structure aware classpath. Maven submodules are supported.
    # Author::   Peter Kofler
    class MavenClasspath < CompositeClasspath
     
      POM_XML = 'pom.xml'
      
      # Check if the _file_ is a valid location for a Maven classpath.
      def self.valid_location(file)
        FileTest.exist?(file) && FileTest.directory?(file) && FileTest.exist?(File.join(file, POM_XML))
      end

      # Create a classpath for a Maven base project _folder_ 
      def initialize(folder)
        raise IOError, "folder #{folder} not a Maven project" if !MavenClasspath::valid_location(folder)
        super()
        @root = folder
        add_if_exist(File.join(@root, 'target/classes'))
        add_if_exist(File.join(@root, 'target/test-classes'))

        # look for submodules
        Dir.entries(@root).each do |dir|
          next if dir =~ /^(?:\.|\.\.|src|target|pom.xml|\.settings)$/
          folder = File.join(@root, dir)
          add_element(MavenClasspath.new(folder)) if MavenClasspath::valid_location(folder)
        end
      end

      def to_s
        File.join(@root, POM_XML).to_s
      end

      private

      def add_if_exist(folder)
        add_file_name(folder) if FileTest.exist?(folder) && FileTest.directory?(folder)
      end

    end

  end
end
