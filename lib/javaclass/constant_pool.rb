require 'javaclass/string_ux'
require 'javaclass/constants/value'
require 'javaclass/constants/single_reference'
require 'javaclass/constants/double_reference'

module JavaClass # :nodoc:
  
  # Container of the constant pool.
  # Author::   Peter Kofler
  class ConstantPool
    
    # Types of constant pool constants.
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
    
    # The size in bytes of this constant pool.
    attr_reader :size
    
    # Parse the constant pool from the byte _data_ at position _start_ which is usually 8.
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
    
    # Return the number of pool items.
    def item_count
      @item_count-1
    end
    
    # Return the ordered list of pool constants.
    def items
      @pool.keys.sort.collect { |k| @pool[k] }
    end
    
    # Return a debug dump of this pool.
    def dump
      ["  Constant pool:"]+ @pool.keys.sort.collect { |k| "const ##{k} = #{@pool[k].dump}"}
    end
    
  end
  
end

