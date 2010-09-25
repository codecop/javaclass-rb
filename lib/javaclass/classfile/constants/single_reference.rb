require 'javaclass/classfile/constants/base'

module JavaClass 
  module ClassFile 
    module Constants 
      
      # Superclass of single reference constants like +ConstantClass+ (+Class+) in the constant pool. 
      # Author::   Peter Kofler
      class SingleReference < Base
        
        attr_reader :first_index
        
        # Define a single reference into _pool_ from _data_ beginning at _start_
        def initialize(pool, data, start, name=nil)
          super(name)
          @tag = data.u1(start)
          
          @enclosing_pool = pool
          @first_index = data.u2(start+1)
        end
        
        # Return the value, which is the referenced value from the pool.
        def first_value
          get(@first_index)
        end
        alias to_s first_value
        
        # Return part of debug output.
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
        alias name_index first_index
        def initialize(pool, data, start)
          super(pool, data, start, "class")
        end
        alias class_name first_value
      end
      
      class ConstantString < SingleReference
        alias string_index first_index
        def initialize(pool, data, start) 
          super(pool, data, start)
        end
        alias string_value first_value
      end
      
    end
  end
end