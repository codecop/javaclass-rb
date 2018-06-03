require 'javaclass/classfile/access_flag_constants'
require 'javaclass/classfile/class_format_error'

module JavaClass
  module ClassFile

    # The general JVM access flags.
    # Author::   Peter Kofler
    class AccessFlags
      include AccessFlagsConstants

      attr_reader :flags
      
      def initialize(flags)
        @flags = flags
        correct_flags
        assert_flags
      end
      
      def correct_flags
        if interface? && !abstract?
          # JDK 1.0 and 1.1 do have non abstract interfaces, fix it
          @flags = @flags | ACC_ABSTRACT
        end
      end
      private :correct_flags
      
      def assert_flags
        raise ClassFormatError, "inconsistent flags #{flags} (abstract and final)" if abstract? && final?
        raise ClassFormatError, "inconsistent flags #{flags} (interface not abstract)" if interface? && !abstract?
        raise ClassFormatError, "inconsistent flags #{flags} (interface is final)" if interface? && final?
        raise ClassFormatError, "inconsistent flags #{flags} (annotation not interface)" if annotation? && !interface?
      end
      private :assert_flags

      # Return +true+ if the bit _flag_ is set.
      def is?(flag)
        (@flags & flag) != 0
      end
      
      # Return +true+ if the class is public.
      def public?
        is? ACC_PUBLIC
      end
      alias accessible? public?

      def static?
        is? ACC_STATIC
      end
      
      def final?
        is? ACC_FINAL
      end
     
      def abstract?
        is? ACC_ABSTRACT
      end
      
      def synthetic?
        is? ACC_SYNTHETIC
      end

      def interface?
        is? ACC_INTERFACE
      end

      def enum?
        is? ACC_ENUM
      end

      def annotation?
        is? ACC_ANNOTATION
      end

      def module?
        is? ACC_MODULE
      end
      
      # Return the hex word of the flag.
      def flags_hex
        format '%4.4X', @flags
      end
    end

  end
end
