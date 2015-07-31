require 'javaclass/classfile/access_flags'
require 'javaclass/classfile/class_format_error'

module JavaClass
  module ClassFile

    # The access flags of a class or interface.
    # Author::   Peter Kofler
    class ClassAccessFlags < AccessFlags

      def initialize(flags)
        super
        correct_flags
        assert_flags
      end
      
      def correct_flags
        if interface_flag? && !abstract?
          # JDK 1.0 and 1.1 do have non abstract interfaces, fix it
          @flags = @flags | ACC_ABSTRACT
        end
      end
      private :correct_flags
      
      def assert_flags
        raise ClassFormatError, "inconsistent flags #{flags} (abstract and final)" if abstract? && final?
        raise ClassFormatError, "inconsistent flags #{flags} (interface not abstract)" if interface_flag? && !abstract?
        raise ClassFormatError, "inconsistent flags #{flags} (interface is final)" if interface_flag? && final?
        raise ClassFormatError, "inconsistent flags #{flags} (annotation not interface)" if annotation? && !interface_flag?
        raise ClassFormatError, "inconsistent flags #{flags} (other value #{flags & ACC_CLASS_OTHER})" if (flags & ACC_CLASS_OTHER) != 0
      end
      private :assert_flags

      # Return +true+ if the class is public.
      def public?
        is? ACC_PUBLIC
      end
      alias accessible? public?

      def final?
        is? ACC_FINAL
      end
     
      def abstract?
        is? ACC_ABSTRACT
      end

      # Is this class a purely abstract class (and not an interface)?
      def abstract_class?
        abstract? && !interface?
      end
      
      def interface_flag?
        is? ACC_INTERFACE
      end

      # Is this class an interface (and not an annotation)?
      def interface?
        interface_flag? && !annotation?
      end
      
      def enum?
        is? ACC_ENUM
      end

      def annotation?
        is? ACC_ANNOTATION
      end

      # Static for inner class declarations.
      def static?
        is? ACC_STATIC
      end

    end

  end
end
