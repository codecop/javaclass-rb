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

      # field
      ACC_VOLATILE = 0x0040
      ACC_TRANSIENT = 0x0080

      # method
      ACC_ACC_BRIDGE = 0x0040
      ACC_VARARGS = 0x0080
      ACC_NATIVE = 0x0100

      ACC_INTERFACE = 0x0200
      ACC_ABSTRACT = 0x0400
      ACC_STRICT = 0x0800
      ACC_SYNTHETIC = 0x1000 # may vary between different compilers
      ACC_ANNOTATION = 0x2000
      ACC_ENUM = 0x4000
      ACC_IMPLICIT = 0x8000 # e.g. default constructor
      # TODO How were Java 1.0's "private protected" fields? set up? (see old JVM spec)

    end

  end
end
