require 'fileutils'
require 'javaclass/gems/zip_file'
require 'javaclass/classpath/temporary_unpacker'
require 'javaclass/java_language'
require 'javaclass/java_name'

module JavaClass

  # Activate temporary unpacking of all JARs. This speeds up loading of classes later.
  def self.unpack_jars!(flag=true)
    @@unpack_jars = flag
  end

  # Return +true+ if JARs should be temporarily unpacked
  def self.unpack_jars?
    defined?(@@unpack_jars) && @@unpack_jars
  end

  module Classpath

    # Abstraction of a ZIP or JAR on the CLASSPATH. May return additional classpath elements for referenced libs.
    # Author::   Peter Kofler
    class JarClasspath

      # Create a classpath with this _jarfile_ .
      def initialize(jarfile)
        @jarfile = jarfile
        raise IOError, "jarfile #{@jarfile} not found" if !FileTest.exist? @jarfile
        raise "#{@jarfile} is no file" if !FileTest.file? @jarfile
        @classes = list_classes.collect { |cl| cl.to_javaname }
        @manifest = JavaClass::Gems::ZipFile.new(@jarfile).read('META-INF/MANIFEST.MF')

        setup_cache if JavaClass.unpack_jars?
      end

      # Return +true+ as this classpath element is a jar.
      def jar?
        @manifest != nil
      end

      # Return list of additional classpath elements defined in the manifest of this jarfile.
      def additional_classpath
        if @manifest
          cp = @manifest.gsub(/\s{4,}/, ' ').scan(/^(.*): (.*)\s*$/).find { |p| p[0] == 'Class-Path' }
          if cp
            cp[1].strip.split.collect { |jar| File.join(File.dirname(@jarfile), jar) }
          else
            []
          end
        else
          []
        end
      end

      # Return the list of class names found in this jar.
      def names
        @classes.dup
      end

      # Return if _classname_ is included in this jar.
      def includes?(classname)
        @classes.include?(classname.to_javaname.to_class_file)
      end

      # Load the binary data of the file name or class name _classname_ from this jar.
      def load_binary(classname)
        if JavaClass.unpack_jars?
          @delegate.load_binary(classname)
        else
          raise "class #{classname} not found in #{@jarfile}" unless includes?(classname)
          JavaClass::Gems::ZipFile.new(@jarfile).read(classname.to_javaname.to_class_file)
        end
      end

      # Return the number of classes in this jar.
      def count
        @classes.size
      end

      def to_s
        @jarfile
      end

      def ==(other)
        other.class == JarClasspath && other.to_s == self.to_s
      end

      def elements
        [self]
      end
      
      private

      # Return the list of classnames (in fact file names) found in this jarfile.
      def list_classes
        list = []
        JavaClass::Gems::ZipFile.new(@jarfile).entries do |entry|
          name = entry.name
          next unless entry.file? and name =~ CLASS_REGEX # class file
          list << name
        end
        list.sort
      end

      # Set up the temporary unpacking. This sets the delegate field for future use.
      def setup_cache
        unpacker = TemporaryUnpacker.new(@jarfile)
        unpacker.create_temporary_folder
        unpacker.unpack!
        @delegate = FolderClasspath.new(unpacker.folder)
      end

    end

  end
end
