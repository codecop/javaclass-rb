require 'javaclass/classpath/composite_classpath'

module JavaClass
  module Classpath
    
    # A Maven folder structure aware classpath. Maven submodules are supported.
    # Author::   Peter Kofler
    class MavenClasspath < CompositeClasspath
     
      POM_XML = 'pom.xml'
      
      # Check if the _file_ is a valid location for a Maven classpath.
      def self.valid_location?(file)
        FileTest.exist?(file) && FileTest.directory?(file) && FileTest.exist?(File.join(file, POM_XML))
      end

      # Create a classpath for a Maven base project _folder_ 
      def initialize(folder)
        raise IOError, "folder #{folder} not a Maven project" if !MavenClasspath::valid_location?(folder)
        pom = File.join(folder, POM_XML)
        super(pom)
        add_if_exist(File.join(folder, 'target/classes'))
        add_if_exist(File.join(folder, 'target/test-classes'))

        # look for submodules
        Dir.entries(folder).each do |dir|
          next if dir =~ /^(?:\.|\.\.|src|target|pom.xml|\.settings)$/
          folder = File.join(folder, dir)
          add_element(MavenClasspath.new(folder)) if MavenClasspath::valid_location?(folder)
        end
      end

      private

      def add_if_exist(folder)
        add_file_name(folder) if FileTest.exist?(folder) && FileTest.directory?(folder)
      end

    end

  end
end
