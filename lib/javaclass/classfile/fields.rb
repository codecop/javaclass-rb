require 'javaclass/classfile/attributes/attributes'

module JavaClass
  module ClassFile

    # Container of the fields - skips the fields for now.
    # Author::   Peter Kofler
    class Fields # :nodoc:

      # Size of the whole fields structure in bytes.
      attr_reader :size

      # Parse the field structure from the bytes _data_ beginning at position _start_.
      def initialize(data, start, constant_pool)
        count = data.u2(start)
        @size = 2

        (1..count).each do |i|
          # TODO Implement parsing of fields into Field class

          # access_flags = data.u2(start + @size) # later ... FieldAccessFlag.new(data, start + @size)
          # @size += 2
          # name_index = data.u2(start + @size) # later ... get from ConstantPool
          # @size += 2
          # descriptor_index = data.u2(start + @size) # later ... get from ConstantPool
          # @size += 2
          @size += 6

          attributes = Attributes::Attributes.new(data, start + @size, constant_pool)
          @size += attributes.size
        end
      end

    end

  end
end
