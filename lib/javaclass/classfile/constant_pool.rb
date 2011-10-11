require 'javaclass/string_ux'
require 'javaclass/classfile/constants/value'
require 'javaclass/classfile/constants/single_reference'
require 'javaclass/classfile/constants/double_reference'
require 'javaclass/classfile/class_format_error'

module JavaClass
  module ClassFile

    # Container of the constant pool's constants.
    # Author::   Peter Kofler
    class ConstantPool

      # Types of constants by their +tag+.
      CONSTANT_TYPE_TAGS = {
        CLASS_TAG     = 7 => Constants::ConstantClass,
        FIELD_TAG     = 9 => Constants::ConstantField,
        METHOD_TAG    = 10 => Constants::ConstantMethod,
        INTERFACE_METHOD_TAG = 11 => Constants::ConstantInterfaceMethod,
        STRING_TAG    = 8 => Constants::ConstantString,
        INT_TAG       = 3 => Constants::ConstantInt,
        FLOAT_TAG     = 4 => Constants::ConstantFloat,
        LONG_TAG      = 5 => Constants::ConstantLong,
        DOUBLE_TAG    = 6 => Constants::ConstantDouble,
        NAME_AND_TYPE_TAG = 12 => Constants::ConstantNameAndType,
        ASCIZ_TAG     = 1 => Constants::ConstantAsciz,
      }

      # Size of the whole constant pool in bytes.
      attr_reader :size

      # Parse the constant pool from the bytes _data_ beginning at position _start_ (which is usually 8).
      def initialize(data, start=8)
        @pool = Hash.new # cnt (Fixnum) => constant class

        # parsing
        @item_count = data.u2(start)
        pos = start + 2
        cnt = 1
        while cnt <= @item_count-1

          tag_index = data.u1(pos)
          type = CONSTANT_TYPE_TAGS[tag_index]
          unless type
            # puts dump.join("\n")
            raise ClassFormatError, "const ##{cnt} contains unknown constant pool tag/index #{tag_index} (at pos #{pos} in class).\n" +
                  "allowed are #{CONSTANT_TYPE_TAGS.keys.sort.join(',')}"
          end

          constant = type.new(@pool, data, pos)
          @pool[cnt] = constant
          pos += constant.size
          cnt += constant.slots

        end

        @size = pos - start
      end

      # Return the number of pool items. This number might be larger than +items+ available,
      # because +long+ and +double+ constants take two slots.
      def item_count
        @item_count - 1
      end

      # Return the _index_'th pool item. _index_ is the real index in the pool which may skip numbers.
      def[](index)
        if index < 0 || index > item_count
          raise IndexError, "index #{index} is out of bounds of constant pool"
        end
        @pool[index]
      end

      # Return an array of the ordered list of constants.
      def items
        @pool.keys.sort.collect { |k| self[k] }
      end

      # Return an array of all constants of the given _tags_ types.
      def find(*tags)
        items.find_all { |item| tags.include? item.tag }
      end

      # Return all string constants.
      def strings
        find(STRING_TAG)
      end

      # Return a debug output of the whole pool.
      def dump
        ["  Constant pool:"] + @pool.keys.sort.collect { |k| "const ##{k} = #{self[k].dump}"}
      end

      # Return the constant class from _index_'th pool item.
      def class_item(index)
        if self[index] && !self[index].const_class?
          raise ClassFormatError, "inconsistent constant pool entry #{index} for class, should be Constant Class"
        end
        self[index]
      end

      # Return the constant field from _index_'th pool item.
      def field_item(index)
        if self[index] && !self[index].const_field?
          raise ClassFormatError, "inconsistent constant pool entry #{index} for field, should be Constant Field"
        end
        self[index]
      end

      # Return the constant method from _index_'th pool item.
      def method_item(index)
        if self[index] && !self[index].const_method?
          raise ClassFormatError, "inconsistent constant pool entry #{index} for method, should be Constant Method"
        end
        self[index]
      end

    end

  end
end