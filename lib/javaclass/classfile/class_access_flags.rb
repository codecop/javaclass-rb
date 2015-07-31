require 'javaclass/classfile/access_flags'
require 'javaclass/classfile/class_format_error'

module JavaClass
  module ClassFile

    # The access flags of a class or interface.
    # Author::   Peter Kofler
    class ClassAccessFlags < AccessFlags

      # Bitmask for unknown/not supported flags on classes.
      ACC_OTHER = 0xffff ^ ACC_PUBLIC ^ ACC_STATIC ^ ACC_FINAL ^ ACC_SUPER ^ ACC_INTERFACE ^ ACC_ABSTRACT ^ ACC_SYNTHETIC ^ ACC_ENUM ^ ACC_ANNOTATION

      def initialize(flags)
        super
        assert_flags
      end

      def assert_flags
        raise ClassFormatError, "inconsistent flags #{flags} (other value #{flags & ACC_OTHER})" if (flags & ACC_OTHER) != 0
      end
      private :assert_flags

      # Is this class a purely abstract class (and not an interface)?
      def abstract_class?
        abstract? && !interface_class?
      end

      # Is this class an interface (and not an annotation)?
      def interface_class?
        interface? && !annotation?
      end

    end

  end
end
