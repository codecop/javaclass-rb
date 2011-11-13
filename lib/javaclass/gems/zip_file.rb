require 'zip/zipfilesystem'

# Patch the zip for invalid flags found in some JARs.
module Zip # :nodoc:all
  class ZipEntry

    # unsomment to not swallow errors, else we get nil entries later
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
        Zip::ZipFile.foreach(@archive) do |entry|
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

