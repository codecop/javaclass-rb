require 'fileutils'
require 'zip/zipfilesystem'
require 'javaclass/java_name'

module JavaClass
  
  # Activate temporary unpacking of all JAR classpath elements. This speeds up loading of classes.
  def self.unpack_jars!(flag=true)
    @@unpack_jars = flag
  end

  def self.unpack_jars?
    defined?(@@unpack_jars) && @@unpack_jars
  end
    
  module Classpath

    # Abstraction of a ZIP or JAR on the CLASSPATH.
    # Author::   Peter Kofler
    class JarClasspath
    
      # Return the list of classnames found in this _jarfile_ .
      def initialize(jarfile)
        @jarfile = jarfile
        raise IOError, "jarfile #{@jarfile} not found" if !FileTest.exist? @jarfile
        raise "#{@jarfile} is no file" if !FileTest.file? @jarfile
        @classes = list_classes.collect { |cl| cl.to_javaname }
        @manifest =
        begin
          Zip::ZipFile.open(@jarfile) { |zipfile| zipfile.file.read("META-INF/MANIFEST.MF") }
        rescue
          nil
        end

        setup_cache if JavaClass.unpack_jars?
      end

      # Return if the given classpath element is a jar.
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
          Zip::ZipFile.open(@jarfile) do |zipfile|
            zipfile.file.read(classname.to_javaname.to_class_file)
          end
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

      private

      # Return the list of classnames (in fact file names) found in this jarfile.
      def list_classes
        list = []
        Zip::ZipFile.foreach(@jarfile) do |entry|
          name = entry.name
          next unless entry.file? and name =~ /\.class$/ # class file
          list << name
        end
        list.sort
      end

      # Set up the unpack cache for the _jarfile_ .
      def setup_cache
        temporary_folder = File.join(find_temp_folder, "temp_#{File.basename(@jarfile)}_#{Time.now.to_i.to_s}")
        at_exit { FileUtils.rm_r(temporary_folder) }
        unpack_jar(temporary_folder)
        @delegate = FolderClasspath.new(temporary_folder)
      end

      # Return the temp folder if set
      def find_temp_folder
        return ENV['TEMP'] if ENV['TEMP']
        return ENV['TMP'] if ENV['TMP']
        '/tmp'
      end
      
      # Unpack the jarfile temporarily into the temporary folder.
      def unpack_jar(temporary_folder)
        # TODO use unzip first, fallback by hand
        Zip::ZipFile.open(@jarfile) do |zip_file|
          zip_file.each do |entry|
            name = entry.name
            next unless entry.file? and name =~ /\.class$/ # class file

            f_path = File.join(temporary_folder, entry.name)
            FileUtils.mkdir_p(File.dirname(f_path))
            zip_file.extract(entry, f_path) # unless File.exist?(f_path)
          end
        end
      end

    end

  end
end