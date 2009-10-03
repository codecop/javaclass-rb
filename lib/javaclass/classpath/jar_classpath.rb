require 'zip/zipfilesystem'

module JavaClass
  module Classpath # :nodoc:
    
    # Author::   Peter Kofler
    class JarClasspath
      
      # Return the list of classnames found in this _jarfile_ . 
      def initialize(jarfile)
        @jarfile = jarfile
        @classes = list_classes
        @manifest =
        begin
          Zip::ZipFile.open(@jarfile) do |zipfile|
            zipfile.file.read("META-INF/MANIFEST.MF")
          end
        rescue
          nil
        end
      end
      
      # Return if the given classpath element is a jar
      def jar?
        @manifest != nil
      end

      # Return list of additional classpath elements relative to this jarfile.
      def additional_classpath
        if @manifest
          cp = @manifest.gsub(/\s{4,}/, ' ').scan(/^(.*): (.*)\s*$/).find { |p| p[0] == 'Class-Path' }
          if cp
            cp[1].strip.split
          else
            []
          end
        else
          []
        end
      end
      
      # Return the list of class names found in this jar.
      def class_names
        @classes.dup
      end
      
      #/**
      # * Abstraction of a place where to find the physical class files for a given full class name. This must also configure
      # * the <code>org.apache.bcel.Repository</code> to use the right repository for BCEL automatic class loading, i.e. for
      # * interfaces.
      # */
      
      def includes?(classname)
        @classes.include?(normalize(classname))
      end
      
      # Load the binary data of the file name or class name _classname_ from this jar.
      def load_binary(classname)
        raise "class #{classname} not found in #{@jarfile}" unless includes?(classname)
        Zip::ZipFile.open(@jarfile) do |zipfile|
          zipfile.file.read(normalize(classname))
        end
      end
      
      # Return the number of classes in this jar.
      def count
        @classes.size
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
        list
      end
      
      # Normalize the file name or class name _classname_ to be a file name in the jar.
      def normalize(classname)
        if classname !~ /\.class$/
          classname.gsub(/\./,'/') + '.class'
        else
          classname
        end
      end
      
    end
    
  end
end