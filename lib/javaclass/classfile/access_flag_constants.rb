module JavaClass
  module ClassFile

    # Access flags as defined by JVM spec.
    # Author::   Peter Kofler
    module AccessFlagsConstants

      ACC_PUBLIC = 0x0001
      ACC_FINAL = 0x0010
      ACC_SUPER = 0x0020 # old invokespecial instruction semantics
      ACC_INTERFACE = 0x0200
      ACC_ABSTRACT = 0x0400
      ACC_INNER = 0x1000 # TODO What is this flag doing?
      ACC_ANNOTATION = 0x2000
      ACC_ENUM = 0x4000
      # TODO How were Java 1.0's "private protected" fields? set up? (see JVM spec)

      # Bitmask for unknown/not supported flags.
      ACC_OTHER = 0xffff ^ ACC_PUBLIC ^ ACC_FINAL ^ ACC_SUPER ^ ACC_INTERFACE ^ ACC_ABSTRACT ^ ACC_INNER ^ ACC_ENUM ^ ACC_ANNOTATION

    end

  end
end
