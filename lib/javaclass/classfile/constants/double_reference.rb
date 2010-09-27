require 'javaclass/classfile/constants/single_reference'

module JavaClass 
  module ClassFile 
    module Constants 
      
      # Superclass of double reference constants like +ConstantField+ (+FieldRef+) in the constant pool. 
      # Author::   Peter Kofler
      class DoubleReference < SingleReference
        
        attr_reader :second_index
        
        # Define a double reference into _pool_ from _data_ beginning at _start_
        def initialize(pool, data, start, name=nil)
          super(pool, data, start, name)
          @size = 5
          
          @second_index = data.u2(start+3)
        end
        
        # Return the second value, which is the referenced value from the pool.
        def second_value
          get(@second_index)
        end
        
        # Return the value, which are both referenced values from the pool.
        def to_s
          "#{super}.#{second_value}"
        end
        
        # Return part of debug output.
        def dump
          "#{@name}\t##{@first_index}.##{@second_index};\t//  #{to_s}"
        end
        
      end
      
      class ConstantField < DoubleReference # ZenTest SKIP
        alias class_index first_index 
        alias name_and_type_index second_index 
        def initialize(pool, data, start) 
          super(pool, data, start)
        end
        def first_value 
          # is a classname
          super.to_javaname
        end
        alias class_name first_value
        alias signature second_value
      end
      
      class ConstantMethod < DoubleReference # ZenTest SKIP
        alias class_index first_index 
        alias name_and_type_index second_index 
        def initialize(pool, data, start) 
          super(pool, data, start)
        end  
        def first_value 
          # is a classname
          super.to_javaname
        end
        alias class_name first_value
        alias signature second_value
      end
      
      class ConstantInterfaceMethod < DoubleReference # ZenTest SKIP
        alias class_index first_index 
        alias name_and_type_index second_index 
        def initialize(pool, data, start) 
          super(pool, data, start)
        end  
        def first_value 
          # is a classname
          super.to_javaname
        end
        alias class_name first_value
        alias signature second_value
      end
      
      class ConstantNameAndType < DoubleReference # ZenTest SKIP
        alias name_index first_index 
        alias descriptor_index second_index 
        def initialize(pool, data, start)
          super(pool, data, start)
        end
        
        def to_s
          "#{get(name_index)}:#{get(descriptor_index)}"
        end
        
        def dump
          "#{@name}\t##{name_index}:##{descriptor_index};//  #{to_s}"
        end
      end
      
    end
  end
end
