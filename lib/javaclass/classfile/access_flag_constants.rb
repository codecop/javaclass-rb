module JavaClass
  module ClassFile

    # Access flags as defined by JVM spec.
    # Author::   Peter Kofler
    module AccessFlagsConstants

      ACC_PUBLIC = 0x0001
      
      ACC_PRIVATE = 0x0002  
      ACC_PROTECTED = 0x0004
      ACC_STATIC = 0x0008

      ACC_FINAL = 0x0010
      ACC_SUPER = 0x0020 # old invokespecial instruction semantics
      ACC_INTERFACE = 0x0200
      ACC_ABSTRACT = 0x0400
      ACC_SYNTHETIC = 0x1000
      ACC_ANNOTATION = 0x2000
      ACC_ENUM = 0x4000
      # TODO How were Java 1.0's "private protected" fields? set up? (see old JVM spec)

      # Bitmask for unknown/not supported flags on classes.
      ACC_CLASS_OTHER = 0xffff ^ ACC_PUBLIC ^ ACC_FINAL ^ ACC_SUPER ^ ACC_INTERFACE ^ ACC_ABSTRACT ^ ACC_SYNTHETIC ^ ACC_ENUM ^ ACC_ANNOTATION
      # old alias, deprecated
      ACC_OTHER = ACC_CLASS_OTHER # :nodoc: 

    end

  end
end
