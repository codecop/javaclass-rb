require 'fileutils'
require 'zip/zipfilesystem'
require 'javaclass/java_language'

module JavaClass
  module Classpath

    # Unpack a JAR (ZIP) into a temporary folder.
    # Author::   Peter Kofler
    class TemporaryUnpacker

      # Command templates for external too like 7zip or zip.
      COMMANDS = [
        # 7zip 9.20
        '7za x -bd -o<folder> -y <jar> 2>&1',
        # Unzip 5.42
        'unzip -o -qq <jar> -d <folder> 2>&1',
        # WinZip 8.1
        'WinZip32.exe -min -e -o <jar> <folder>',
      ]

      # The temporary folder. This folder will be deleted after Ruby shuts down.
      attr_reader :folder

      # Set the given _jarfile_ to unpack.
      def initialize(jarfile)
        @jarfile = jarfile

        if !defined?(@@unpack_strategies)
          # use unzip first, fallback by hand
          @@unpack_strategies = COMMANDS.map{ |c| Proc.new{ unpack_shell(c) } } + [ Proc.new{ unpack_ruby } ]
        end
      end

      # Create the temporary folder where it will be unpacked to.
      def create_temporary_folder
        folder = File.join(find_temp_folder, "temp_#{File.basename(@jarfile)}_#{Time.now.to_i.to_s}")
        FileUtils.mkdir_p(folder)
        at_exit { FileUtils.rm_r(folder) }
        @folder = folder
      end

      # Unpack the given jar file.
      def unpack!
        raise 'no temporary folder created' unless defined?(@folder) && @folder

        # Find the first working strategy and keep it
        if ! @@unpack_strategies.first.call
          @@unpack_strategies.delete_at(0)
          raise 'no suitable unpack strategy found' if @@unpack_strategies.empty?
          unpack!
        end
      end

      # Return the temp folder if a variable is set, else returm /tmp.
      def find_temp_folder
        escape_folder(
        if ENV['TEMP']
          ENV['TEMP'] # Windows
        elsif ENV['TMP']
          ENV['TMP']
        else
          '/tmp'
        end
        )
      end

      private

      # Escape _folder_ if it contains blanks.
      def escape_folder(folder)
        if folder =~ / / then "\"#{folder}}\"" else folder end
      end

      # Unpack using external executeable using the _command_ string. Return +true+ for success.
      def unpack_shell(command)
        `#{command.gsub(/<folder>/, escape_folder(@folder)).gsub(/<jar>/, escape_folder(@jarfile))}`
        $?.to_i == 0
      end

      # Unpack using Ruby's Rubyzip gem. This is very slow. Return +true+ for success.
      def unpack_ruby
        Zip::ZipFile.open(@jarfile) do |zip_file|
          zip_file.each do |entry|
            name = entry.name
            next unless entry.file? and name =~ CLASS_REGEX # class file

            f_path = File.join(@folder, entry.name)
            FileUtils.mkdir_p(File.dirname(f_path))
            zip_file.extract(entry, f_path) unless File.exist?(f_path)
          end
        end
        true
      end

    end

  end
end