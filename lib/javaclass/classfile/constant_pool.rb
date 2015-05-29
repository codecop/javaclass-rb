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
      # TODO Java7/Java8 JDK, implement 3 new tags, see https://docs.oracle.com/javase/specs/jvms/se7/html/jvms-4.html#jvms-4.4

      # Size of the whole constant pool in bytes.
      attr_reader :size

      # Parse the constant pool from the bytes _data_ beginning at position _start_ (which is usually 8).
      def initialize(data, start=8)
        creator = PoolCreator.new(data, start)
        creator.create!
        
        @pool = creator.pool # cnt (Fixnum) => constant class
        @item_count = creator.item_count
        
        @size = @pool.values.inject(0) { |sum, constant| sum + constant.size } + 2
      end

      # Return the number of pool items. This number might be larger than +items+ available,
      # because +long+ and +double+ constants take two slots.
      def item_count
        @item_count - 1
      end

      # Return the _index_'th pool item. _index_ is the real index in the pool which may skip numbers.
      def[](index)
        check_index(index)
        @pool[index]
      end

      def check_index(index)
        if index < 0 || index > item_count
          raise IndexError, "index #{index} is out of bounds of constant pool"
        end
      end
      private :check_index

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
    
    class PoolCreator # :nodoc:

      attr_reader :pool, :item_count
      
      def initialize(data, start)
        @data = data
        @start = start
      end
      
      def create!
        create_pool
        fill_pool
      end

      def create_pool
        @pool = {}
        @item_count = @data.u2(@start)
        @pos = @start + 2
      end
      
      def fill_pool
        @cnt = 1
        while @cnt <= @item_count-1
          create_next_constant
        end
      end
            
      def create_next_constant
        type = determine_constant_type
        constant = type.new(@pool, @data, @pos)
        @pool[@cnt] = constant
        @pos += constant.size
        @cnt += constant.slots
      end
      
      def determine_constant_type
        tag_index = @data.u1(@pos)
        type = ConstantPool::CONSTANT_TYPE_TAGS[tag_index]
        unless type
          raise ClassFormatError, "const ##{@cnt} contains unknown constant pool tag/index #{tag_index} (at pos #{@pos} in class).\n" +
                "allowed are #{ConstantPool::CONSTANT_TYPE_TAGS.keys.sort.join(',')}"
        end
        type
      end
      
    end

  end
end