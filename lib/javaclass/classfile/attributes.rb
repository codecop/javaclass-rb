module JavaClass
  module ClassFile

    # Container of the attributes.
    # Author::   Peter Kofler
    class Attributes

      # Size of the whole attributes structure in bytes.
      attr_reader :size
      # Return the number of attributes.
      attr_reader :count

      # Parse the attributes structure from the bytes _data_ beginning at position _start_.
      def initialize(data, start)
        @count = data.u2(start)
        @size = 2

        (1..@count).each  do |i|
          attribute_name_index = data.u2(start + @size) # later ... get from ConstantPool
          @size += 2
          attribute_length = data.u4(start + @size)
          @size += 4

          @size += attribute_length # skip for now
        end

      end

    end

  end
end
