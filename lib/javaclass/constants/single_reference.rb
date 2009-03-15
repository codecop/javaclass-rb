require 'javaclass/constants/base'

module JavaClass # :nodoc:
  module Constants # :nodoc:
    
    # Superclass of single reference value constants in the constant pool. 
    # Author::   Peter Kofler
    class SingleReference < Base
      
      attr_reader :first_index
      
      # Define a single reference into _pool_ from _data_ beginning at _start_
      def initialize(pool, data, start, name=nil)
        super(name)
        @cp_info_tag = data.u1(start)
        
        @enclosing_pool = pool
        @first_index = data.u2(start+1)
      end
      
      # Return the value, which is the referenced value.
      def to_s
        get(@first_index)
      end
      
      def dump
        super + "##{@first_index};\t//  #{to_s}"
      end
      
      protected
      
      # Get a reference _ref_ from the +enclosing_pool+
      def get(ref)
        @enclosing_pool[ref].to_s
      end
      
    end
    
    class ConstantClass < SingleReference
      def initialize(pool, data, start)
        super(pool, data, start, "class")
      end
    end
    
    class ConstantString < SingleReference
      def initialize(pool, data, start) 
        super(pool, data, start)
      end
    end
    
  end
end
