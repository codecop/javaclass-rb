require 'fileutils'
require 'javaclass/gems/zip_file'
require 'javaclass/classpath/temporary_unpacker'
require 'javaclass/classpath/file_classpath'
require 'javaclass/java_language'
require 'javaclass/java_name'

module JavaClass

  # Activate temporary unpacking of all JARs. This speeds up loading of classes later. 
  def self.unpack_jars!(flag=:unpack)
    @@unpack_jars = flag
  end

  # Return +true+ if JARs should be temporarily unpacked
  def self.unpack_jars?
    defined?(@@unpack_jars) && @@unpack_jars
  end

  module Classpath

    # Abstraction of a ZIP or JAR on the CLASSPATH. May return additional classpath 
    # elements for referenced libs. This is a leaf in the classpath tree.
    # Author::   Peter Kofler
    class JarClasspath < FileClasspath

      # Check if the _file_ is a valid location for a jar classpath.
      def self.valid_location?(file)
        FileTest.exist?(file) && FileTest.file?(file) && FileTest.size(file) > 0 && file =~ /\.jar$|\.zip$/
      end
      
      # Create a classpath with this _jarfile_ .
      def initialize(jarfile)
        super(jarfile)
        unless JarClasspath::valid_location?(jarfile)
          raise IOError, "jarfile #{jarfile} not found/no file"
        end
        @jarfile = jarfile
        init_classes
        @manifest = JavaClass::Gems::ZipFile.new(@jarfile).read('META-INF/MANIFEST.MF')
        setup_cache if JavaClass.unpack_jars?
      end
      
      # Return +true+ as this classpath element is a jar. Zip files return +false+ as well.
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

      # Return the list of class names found in this jar. An additional block is used as _filter_ on class names.
      def names(&filter)
        if block_given?
          @class_names.find_all { |n| filter.call(n) }
        else
          @class_names.dup
        end
      end

      # Return if _classname_ is included in this jar.
      def includes?(classname)
        @class_lookup[to_key(classname).file_name]
      end

      # Load the binary data of the file name or class name _classname_ from this jar.
      def load_binary(classname)
        key = to_key(classname)
        if JavaClass.unpack_jars?
          @delegate.load_binary(key)
        else
          unless includes?(key)
            raise ClassNotFoundError.new(key, @jarfile)
          end
          JavaClass::Gems::ZipFile.new(@jarfile).read(key).freeze
        end
      end

      # Return the number of classes in this jar.
      def count
        @class_names.size
      end

      private

      # Return the list of classnames (in fact file names) found in this jarfile.
      def list_classes
        list = []
        JavaClass::Gems::ZipFile.new(@jarfile).entries do |entry|
          name = entry.name
          next unless entry.file? and name =~ JavaLanguage::CLASS_REGEX # class file
          list << name
        end
        list
      end

      # Set up the class names.
      def init_classes
        @class_names = list_classes.
          reject { |n| n =~ /package-info\.class$/ }.
          find_all { |n| valid_java_name?(n) }.
          sort.
          collect { |cl| JavaClassFileName.new(cl) } 
        pairs = @class_names.map { |name| [name.file_name, 1] }.flatten
        @class_lookup = Hash[ *pairs ] # file_name (String) => anything
      end
      
      def valid_java_name?(name)
        if JavaClassFileName.valid?(name) 
          true
        else
          warn("skipping invalid class file name #{name} in classpath #{@jarfile}") 
          false
        end
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
