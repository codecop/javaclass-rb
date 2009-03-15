require 'javaclass/constants/base'

module JavaClass # :nodoc:
  module Constants # :nodoc:
    
    # Superclass of value constants in the constant pool. 
    # Author::   Peter Kofler
    class Value < Base
      
      attr_reader :value
      
      # Create a new value with a downcase name.
      def initialize(name=self.class.to_s[/::[^:]+$/][10..-1].downcase)
        super(name)
      end
      
      # Return the value as String.
      def to_s
        @value.to_s
      end
      
      def dump
        super + "#{@value}"
      end
      
      protected
      
      # Define a +value+ from _data_ beginning at _start_ withe _size_ and _slots_
      def get_value(data, start, size, slots=1)
        @cp_info_tag = data.u1(start)
        @size = size
        @slots = slots
        
        data[start+1..start+size-1]
      end
      
    end
    
    class ConstantInt < Value
      def initialize(pool, data, start) 
        super()
        @value = get_value(data, start, 5).u4
      end
      
      def dump
        super + ';'
      end
    end
    
    class ConstantFloat < Value
      def initialize(pool, data, start) 
        super()
        @value = get_value(data, start, 5).single 
      end
      def to_s
        super.upcase # sprintf('%E',@value)
      end
      def dump
        super + 'f;'
      end
    end
    
    class ConstantLong < Value
      def initialize(pool, data, start) 
        super()
        @value = get_value(data, start, 9, 2).u8
      end
      def dump
        super + 'l;'
      end
    end
    
    class ConstantDouble < Value
      def initialize(pool, data, start) 
        super()
        @value = get_value(data, start, 9, 2).double
      end
      def to_s
        @value.to_s.upcase # sprintf('%E',@value)
      end
      def dump
        super + 'd;'
      end
    end
    
    class ConstantAsciz < Value
      alias string value
      def initialize(pool, data, start) 
        super('Asciz')
        @cp_info_tag = data.u1(start)
        
        @length = data.u2(start+1)
        @size = 3 + @length
        @value = data[start+3..start+3+@length-1]
        
        #if @value =~ /\.java$/
        #  dump.insert(0, "  SourceFile: \"#{@value}\"")
        #  dump.insert(0, "Compiled from \"#{@value}\"")
        #end
      end
      
      def dump
        super + ';'
      end
    end
    
  end
end
