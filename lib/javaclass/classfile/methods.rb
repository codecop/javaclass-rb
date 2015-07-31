module JavaClass
  module ClassFile

    # Container of the methods.
    # Author::   Peter Kofler
    class Methods

      # Size of the whole methods structure in bytes.
      attr_reader :size

      # Parse the method structure from the bytes _data_ beginning at position _start_.
      def initialize(data, start=8)
        # TODO Implement parsing of methods of the JVM spec
        #    u2 methods_count;
        #    method_info methods[methods_count];
        #        method_info {
        #            u2             access_flags;
        #            u2             name_index;
        #            u2             descriptor_index;
        #            u2             attributes_count;
        #            attribute_info attributes[attributes_count];
        #        }
        # count = data.u2(pos)
        # @methods = data.u2rep(count, pos + 2).collect { |i| @constant_pool.method_item(i) }
        # pos += 2 + each method is 8 + n*(6+x)

        @size = 0
      end

      # Return the number of methods. 
      def count
        0
      end
      
    end

  end
end
