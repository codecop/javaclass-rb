require 'zip/zipfilesystem'

module JavaClass
  module Gems # :nodoc:

    # Abstraction of a Zip archive.
    # Author::   Peter Kofler
    class ZipFile
      def initialize(file)
        @archive = file
      end

      # Read the _file_ from archive.
      def read(file)
        begin
          Zip::ZipFile.open(@archive) { |zipfile| zipfile.file.read(file) }
        rescue
          nil
        end
      end

      # List the entries of this zip for the block given.
      def entries(&block)
        begin
          Zip::ZipFile.foreach(@archive) do |entry|
            block.call(ZipEntry.new(entry))
          end
        rescue
          # skip bug in zip for certain JARs
          warn("could not open archive #{@archive}: #{$!}")
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

