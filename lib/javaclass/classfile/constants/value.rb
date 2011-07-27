require 'javaclass/classfile/constants/base'

module JavaClass 
  module ClassFile 
    module Constants 
      
      # Superclass of value constants like +ConstantInt+ (+Integer+) in the constant pool. 
      # Author::   Peter Kofler
      class Value < Base
        
        attr_reader :value
        
        # Create a constant value with an optional downcase _name_
        def initialize(name=self.class.to_s[/::[^:]+$/][10..-1].downcase)
          super(name)
        end
        
        # Return the value as string.
        def to_s
          @value.to_s
        end
        
        # Return part of debug output.
        def dump
          super + "#{to_s}"
        end
        
        protected
        
        # Define a +value+ from _data_ beginning at position _start_ with the _size_ in bytes and _slots_ (1 or 2).
        def get_value(data, start, size, slots=1)
          @tag = data.u1(start)
          @size = size
          @slots = slots
          
          data[start+1..start+size-1]
        end
        
        # Dummy method to "fix" unused warning of param _pool_ in Eclipse.
        def silence_unused_warning(pool)
          raise "pool is nil" unless pool
        end
        
      end
      
      class ConstantInt < Value # ZenTest SKIP
        def initialize(pool, data, start) 
          super()
          silence_unused_warning(pool)
          @value = get_value(data, start, 5).u4
        end
        
        def dump
          super + ';'
        end
      end
      
      class ConstantFloat < Value # ZenTest SKIP
        def initialize(pool, data, start) 
          super()
          silence_unused_warning(pool)
          @value = get_value(data, start, 5).single 
        end
        def to_s
          sprintf('%.14E', @value).sub(/E(\+|-)0+/, 'E\\1')
        end
        def dump
          super + 'f;'
        end
      end
      
      class ConstantLong < Value # ZenTest SKIP
        def initialize(pool, data, start) 
          super()
          silence_unused_warning(pool)
          @value = get_value(data, start, 9, 2).u8
        end
        def dump
          super + 'l;'
        end
      end
      
      class ConstantDouble < Value # ZenTest SKIP
        def initialize(pool, data, start) 
          super()
          silence_unused_warning(pool)
          @value = get_value(data, start, 9, 2).double
        end
        def to_s
          sprintf('%.14E', @value).sub(/E(\+|-)0+/, 'E\\1')
        end
        def dump
          super + 'd;'
        end
      end
      
      class ConstantAsciz < Value # ZenTest SKIP
        alias string value
        def initialize(pool, data, start) 
          super('Asciz')
          silence_unused_warning(pool)
          @tag = data.u1(start)
          
          @length = data.u2(start+1)
          @size = 3 + @length
          @value = data[start+3..start+3+@length-1]
        end
        
        def dump
          super + ';'
        end
      end
      
    end
  end
end