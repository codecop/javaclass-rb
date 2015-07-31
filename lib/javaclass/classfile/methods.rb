require 'javaclass/classfile/attributes'

module JavaClass
  module ClassFile

    # Container of the methods.
    # Author::   Peter Kofler
    class Methods

      # Size of the whole methods structure in bytes.
      attr_reader :size
      # Return the number of methods.
      attr_reader :count

      # Parse the method structure from the bytes _data_ beginning at position _start_.
      def initialize(data, start)
        @count = data.u2(start)
        @size = 2

        @methods = (1..@count).collect do |i|
          # TODO Implement parsing of methods of the JVM spec into Method class
          access_flags = data.u2(start + @size) # later ... MethodAccessFlag.new(data, start + @size)
          @size += 2
          name_index = data.u2(start + @size) # later ... get from ConstantPool
          @size += 2
          descriptor_index = data.u2(start + @size) # later ... get from ConstantPool
          @size += 2

          attributes = Attributes.new(data, start + @size)
          @size += attributes.size

          nil
        end
      end

    end

  end
end
