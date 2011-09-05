require 'zip/zipfilesystem'

module JavaClass
  module Gems

    # Abstraction of a Zip archive.
    # Author::   Peter Kofler
    class ZipFile
      def initialize(file)
        @archieve = file
      end

      # Read the _file_ from archive.
      def read(file)
        begin
          Zip::ZipFile.open(@archieve) { |zipfile| zipfile.file.read(file) }
        rescue
          nil
        end
      end

      # List the entries of this zip for the block given.
      def entries(&block)
        Zip::ZipFile.foreach(@archieve) do |entry|
          block.call(ZipEntry.new(entry))
        end
      end

    end
    
    # Abstraction of an entry in a Zip archive.
    # Author::   Peter Kofler
    class ZipEntry

      def initialize(entry)
        @entry = entry
      end
      
      def name
        @entry.name
      end

      def file?
        @entry.file?
      end
    end

  end
end

