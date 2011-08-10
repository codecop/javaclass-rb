require 'fileutils'
require 'javaclass/classpath/jar_classpath'
require 'javaclass/classpath/folder_classpath'

module JavaClass
  module Classpath
    # Unpack all files in this JAR so lookup is faster.
    # Author::   Peter Kofler
    class CachedJarClasspath < JarClasspath
    
      # Return the list of classnames found in this _jarfile_ .
      def initialize(jarfile)
        super(jarfile)
        
        @temporary_folder = File.join(ENV['TEMP'],"temp-#{File.basename(jarfile)}-#{Time.now.to_i.to_s}")
        at_exit { FileUtils.rm_r(@temporary_folder) }
        unpack_jar(jarfile)
        @delegate = FolderClasspath.new(@temporary_folder)
      end

      # Load the binary data of the file name or class name _classname_ from this jar which has been unpacked.
      def load_binary(classname)
        @delegate.load_binary(classname)
      end

      private

      # Unpack the _jarfile_ temporarily into the temporary folder.
      def unpack_jar(jarfile)
        Zip::ZipFile.open(jarfile) do |zip_file|
          zip_file.each do |entry|
            name = entry.name
            next unless entry.file? and name =~ /\.class$/ # class file
            
            f_path = File.join(@temporary_folder, entry.name)
            FileUtils.mkdir_p(File.dirname(f_path))
            zip_file.extract(entry, f_path) # unless File.exist?(f_path)
          end
        end
      end

    end

  end
end