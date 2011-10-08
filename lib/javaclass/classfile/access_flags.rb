require 'javaclass/string_ux'
require 'javaclass/classfile/access_flag_constants'

module JavaClass
  module ClassFile

    # The access flags of a class or interface.
    # Author::   Peter Kofler
    class AccessFlags
      include AccessFlagsConstants

      def initialize(data, pos)
        @flags = data.u2(pos)
        raise "inconsistent flags #{@flags} (abstract and final)" if abstract? && final?
        if interface? && !abstract?
          # JDK 1.0 and 1.1 do have non abstract interfaces, fix it
          @flags = @flags | ACC_ABSTRACT
        end
        raise "inconsistent flags #{@flags} (interface not abstract)" if interface? && !abstract?
        raise "inconsistent flags #{@flags} (interface is final)" if interface? && final?
        raise "inconsistent flags #{@flags} (annotation not interface)" if annotation? && !interface?
        raise "inconsistent flags #{@flags} (other value #{@flags & ACC_OTHER})" if (@flags & ACC_OTHER) != 0
      end

      # Return +true+ if the class is public.
      def public?
        (@flags & ACC_PUBLIC) != 0
      end
      alias accessible? public?

      def final?
        (@flags & ACC_FINAL) != 0
      end

      def abstract?
        (@flags & ACC_ABSTRACT) != 0
      end

      def interface?
        (@flags & ACC_INTERFACE) != 0
      end

      def enum?
        (@flags & ACC_ENUM) != 0
      end

      def annotation?
        (@flags & ACC_ANNOTATION) != 0
      end

      def inner?
        (@flags & ACC_INNER) != 0
      end

    end

  end
end
