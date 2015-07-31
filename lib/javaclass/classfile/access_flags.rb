require 'javaclass/classfile/access_flag_constants'

module JavaClass
  module ClassFile

    # The general JVM access flags.
    # Author::   Peter Kofler
    class AccessFlags
      include AccessFlagsConstants

      attr_reader :flags
      
      def initialize(flags)
        @flags = flags
      end
      
      # Return +true+ if the bit _flag_ is set.
      def is?(flag)
        (@flags & flag) != 0
      end
      
      # Return the hex word of the flag.
      def flags_hex
        format '%4.4X', @flags
      end
    end

  end
end
