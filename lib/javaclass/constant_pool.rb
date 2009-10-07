require 'javaclass/string_ux'
require 'javaclass/constants/value'
require 'javaclass/constants/single_reference'
require 'javaclass/constants/double_reference'

module JavaClass
  
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
      @pool = {} # cnt (fixnum) => constant
      
      # parsing
      @item_count = data.u2(start)
      pos = start + 2
      cnt = 1
      while cnt <= @item_count-1
        
        type = CONSTANT_TYPE_TAGS[data.u1(pos)]
        unless type
          #puts dump.join("\n") 
          raise "const ##{cnt} = unknown constant pool tag #{data[pos]} at pos #{pos} in class"
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
      @item_count-1
    end
    
    # Return the _index_'th pool item. _index_ is the real index in the pool which may skip numbers. 
    def[](index)
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
    
  end
  
end

