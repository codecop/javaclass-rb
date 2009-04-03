require 'javaclass/string_ux'

module JavaClass
  
  # The access flags of a class or interface.
  # Author::   Peter Kofler
  class AccessFlags
    
    # Access flags as defined by JVM spec.
    ACC_PUBLIC = 0x0001    
    ACC_FINAL = 0x0010    
    ACC_SUPER = 0x0020 # old invokespecial instruction semantics    
    ACC_INTERFACE = 0x0200    
    ACC_ABSTRACT = 0x0400
    ACC_OTHER = 0xffff ^ ACC_PUBLIC ^ ACC_FINAL ^ ACC_SUPER ^ ACC_INTERFACE ^ ACC_ABSTRACT
    
    def initialize(data, pos)
      @flags = data.u2(pos)
      raise "inconsistent flags #{flags}" if abstract? && final?
      raise "inconsistent flags #{flags}" if interface? && (!abstract? || final?)
      raise "inconsistent flags #{flags}" if (@flags & ACC_OTHER) != 0
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
    
  end
  
end
