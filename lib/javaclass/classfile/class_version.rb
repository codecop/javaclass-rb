require 'javaclass/string_ux'

module JavaClass
  module ClassFile

    # Version of a class file.
    # Author::   Peter Kofler
    # See::      http://java.sun.com/docs/books/jvms/second_edition/html/ClassFile.doc.html#75883
    class ClassVersion # ZenTest FULL to find method to_s

      attr_reader :minor
      attr_reader :major

      # Extract the class version from the bytes _data_ starting at position _start_ (which is usually 4).
      def initialize(data, start=4)
        # parsing
        @minor = data.u2(start)
        @major = data.u2(start+2)
      end

      # Return the class file version as +major+.+minor+ string like 48.0 (Java 1.4) or 50.0 (Java 6).
      def to_s
        "#{@major}.#{@minor}"
      end

      # Return the version as +major+.+minor+ float.
      def to_f
        if @minor <= 0
          denom = 1.0
        else
          denom = 1.0 * 10**(Math.log10(@minor).floor + 1)
        end

        @major + @minor/denom
      end

      # Return a debug output of this version.
      def dump
        ["  minor version: #{@minor}", "  major version: #{@major}"]
      end

      # Return the JDK version corresponding to this version like "1.6" or "unknown" if none matched.
      def jdk_version
        v = to_f
        if v >= 45.0 && v <= 45.3 # 1.0.2 supports class file format versions 45.0 through 45.3 inclusive.
          '1.0'
        elsif v > 45.3 && v <= 45.65535 # 1.1.X can support class file formats of versions in the range 45.0 through 45.65535 inclusive
          '1.1'
        elsif @major >= 46 && @minor == 0
          "1.#{@major-44}"
        else
          'unknown'
        end
      end

    end

  end
end