begin
  # 0.x name
  require 'zip/zipfilesystem'
  FILESYSTEM = Zip::ZipFile

# Patch the zip for invalid Linux file system flags found in some JARs.
module Zip # :nodoc:all
  class ZipEntry

    # uncomment next method to avoid swallowing errors, else we get +nil+ entries later.
    # def ZipEntry.read_c_dir_entry(io)
    #   entry = new(io.path)
    #   entry.read_c_dir_entry(io)
    #   return entry
    # end
    
    alias :strict_read_c_dir_entry read_c_dir_entry
    
    def read_c_dir_entry(io)  
      staticSizedFieldsBuf = io.read(CDIR_ENTRY_STATIC_HEADER_LENGTH)
      unless (staticSizedFieldsBuf.size == CDIR_ENTRY_STATIC_HEADER_LENGTH)
        raise ZipError, "Premature end of file. Not enough data for zip cdir entry header"
      end

      @header_signature      ,
      @version               , # version of encoding software
      @fstype                , # filesystem type
      @versionNeededToExtract,
      @gp_flags              ,
      @compression_method    ,
      lastModTime            ,
      lastModDate            ,
      @crc                   ,
      @compressed_size       ,
      @size                  ,
      nameLength             ,
      extraLength            ,
      commentLength          ,
      diskNumberStart        ,
      @internalFileAttributes,
      @externalFileAttributes,
      @localHeaderOffset     ,
      @name                  ,
      @extra                 ,
      @comment               = staticSizedFieldsBuf.unpack('VCCvvvvvVVVvvvvvVV')

      unless @header_signature == CENTRAL_DIRECTORY_ENTRY_SIGNATURE
        raise ZipError, "Zip local header magic not found at location '#{localHeaderOffset}'"
      end
      set_time(lastModDate, lastModTime)

      @name = io.read(nameLength)
      if ZipExtraField === @extra
        @extra.merge(io.read(extraLength))
      else
        @extra = ZipExtraField.new(io.read(extraLength))
      end
      @comment = io.read(commentLength)
      unless (@comment && @comment.length == commentLength)
        raise ZipError, "Truncated cdir zip entry header"
      end

      case @fstype
      when FSTYPE_UNIX
        @unix_perms = (@externalFileAttributes >> 16) & 07777

        case (@externalFileAttributes >> 28)
        when 04
          @ftype = :directory
        when 010
          @ftype = :file
        when 012
          @ftype = :link
        else
          # raise ZipInternalError, "unknown file type #{'0%o' % (@externalFileAttributes >> 28)}"
          
          # PKZIP format see http://www.pkware.com/documents/APPNOTE/APPNOTE-6.3.0.TXT
          # external file attributes: (4 bytes)
          # The mapping of the external attributes is host-system dependent (see 'version made by').
          # For MS-DOS, the low order byte is the MS-DOS directory attribute byte. If input came 
          # from standard input, this field is set to zero.
          # for the meaning of these flags see http://unix.stackexchange.com/questions/14705/the-zip-formats-external-file-attribute

          # unknown flag, fall back to name detection
          if name_is_directory?
            @ftype = :directory
          else
            @ftype = :file
          end
          
        end
        
      else
        if name_is_directory?
          @ftype = :directory
        else
          @ftype = :file
        end
      end
    end

  end
end

rescue LoadError
  # 1.x name
  require 'zip/filesystem'
  FILESYSTEM = Zip::File
end

module JavaClass

  # Module for wrappers around used gems to avoid direct dependencies to gems.
  # Author::   Peter Kofler
  module Gems 

    # Abstraction of a Zip archive. Wraps around
    # Zip::ZipFile of {rubyzip}[http://rubyzip.sourceforge.net/]
    # Author::   Peter Kofler
    class ZipFile
      def initialize(file)
        @archive = file
      end

      # Read the _file_ from archive.
      def read(file)
        begin
          FILESYSTEM.open(@archive) { |zipfile| zipfile.file.read(file) }
        rescue
          nil
        end
      end

      # List the entries of this zip for the block given.
      def entries(&block)
        FILESYSTEM.foreach(@archive) do |entry|
          block.call(ZipEntry.new(entry))
        end
      end

    end
    
    # Abstraction of an entry in a Zip archive. Wraps around 
    # Zip::ZipEntry of {rubyzip}[http://rubyzip.sourceforge.net/]
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
