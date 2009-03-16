require 'javaclass/string_ux'
require 'javaclass/constants/value'
require 'javaclass/constants/single_reference'
require 'javaclass/constants/double_reference'

module JavaClass
  
  # Container of the constant pool's constants.
  # Author::   Peter Kofler
  class ConstantPool
    
    # Types of constants by their +tag+.
    CONSTANT_TYPES = {
      7 => Constants::ConstantClass, 
      9 => Constants::ConstantField, 
      10 => Constants::ConstantMethod, 
      11 => Constants::ConstantInterfaceMethod, 
      8 => Constants::ConstantString, 
      3 => Constants::ConstantInt, 
      4 => Constants::ConstantFloat, 
      5 => Constants::ConstantLong, 
      6 => Constants::ConstantDouble, 
      12 => Constants::ConstantNameAndType, 
      1 => Constants::ConstantAsciz,
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
        
        type = CONSTANT_TYPES[data.u1(pos)]
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
    
    # Return a debug output of the whole pool.
    def dump
      ["  Constant pool:"] + @pool.keys.sort.collect { |k| "const ##{k} = #{self[k].dump}"}
    end
    
  end
  
end

