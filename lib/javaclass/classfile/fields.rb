module JavaClass
  module ClassFile

    # Container of the fields.
    # Author::   Peter Kofler
    class Fields

      # Size of the whole fields structure in bytes.
      attr_reader :size

      # Parse the field structure from the bytes _data_ beginning at position _start_.
      def initialize(data, start=8)
        # TODO Implement parsing of fields of the JVM spec 
        #    u2 fields_count;
        #    field_info fields[fields_count];
        #        field_info {
        #            u2             access_flags;
        #            u2             name_index;
        #            u2             descriptor_index;
        #            u2             attributes_count;
        #            attribute_info attributes[attributes_count];
        #        }        
        # count = data.u2(pos)
        # @fields = data.u2rep(count, pos + 2).collect { |i| @constant_pool.field_item(i) }
        # pos += 2 + each field is 8 + n*(6+x)

        @size = 0
      end
      
      # Return the number of fields. 
      def count
        0
      end

    end

  end
end
