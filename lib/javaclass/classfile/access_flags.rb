require 'javaclass/string_ux'

module JavaClass
  module ClassFile 
    
    # The access flags of a class or interface.
    # Author::   Peter Kofler
    class AccessFlags
      
      # Access flags as defined by JVM spec.
      ACC_PUBLIC = 0x0001    
      ACC_FINAL = 0x0010    
      ACC_SUPER = 0x0020 # old invokespecial instruction semantics    
      ACC_INTERFACE = 0x0200    
      ACC_ABSTRACT = 0x0400
      ACC_INNER = 0x1000 # TODO unknown access flag, find in spec
      ACC_ANNOTATION = 0x2000 
      ACC_ENUM = 0x4000
      ACC_OTHER = 0xffff ^ ACC_PUBLIC ^ ACC_FINAL ^ ACC_SUPER ^ ACC_INTERFACE ^ ACC_ABSTRACT ^ ACC_INNER ^ ACC_ENUM ^ ACC_ANNOTATION
      
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
      
    end
    
  end
end