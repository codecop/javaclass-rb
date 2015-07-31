module JavaClass
  module ClassFile

    # Container of the attributes.
    # Author::   Peter Kofler
    class Attributes

      # Size of the whole attributes structure in bytes.
      attr_reader :size
      
      # Parse the attributes structure from the bytes _data_ beginning at position _start_.
      def initialize(data, start=8)
        #    u2 attributes_count;
        #    attribute_info attributes[attributes_count];
        #        attribute_info {
        #            u2 attribute_name_index;
        #            u4 attribute_length;
        #            u1 info[attribute_length];
        #        }
        # count = data.u2(pos)
        # pos += 2 + each info is 6+x
        
        @size = 0
      end
      
      # Return the number of attributes. 
      def count
        0
      end
      
    end

  end
end
