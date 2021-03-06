require 'javaclass/classfile/constants/base'
require 'javaclass/java_name'

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
        def to_s
          first_value
        end

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

      class ConstantClass < SingleReference # ZenTest SKIP
        alias name_index first_index

        def initialize(pool, data, start)
          super(pool, data, start, "class")
        end

        def first_value
          JavaVMName.new(super) # this is a classname
        end
        alias class_name first_value

        def const_class?
          true
        end
      end

      class ConstantString < SingleReference # ZenTest SKIP
        alias string_index first_index

        def initialize(pool, data, start)
          super(pool, data, start)
        end
        alias string_value first_value
      end

      class ConstantMethodHandle < SingleReference # ZenTest SKIP
        alias method_handle_index first_index
  
        def initialize(pool, data, start)
          super(pool, data, start)
  
          @kind = data.u1(start+1)
          @first_index = data.u2(start+2)
          @size = 4
        end
        alias method_handle_value first_value
      end
      
      class ConstantMethodType < SingleReference # ZenTest SKIP
        alias method_type_index first_index

        def initialize(pool, data, start)
          super(pool, data, start)
        end
        alias method_type_value first_value
      end
      
      class ConstantInvokeDynamic < SingleReference # ZenTest SKIP
        alias name_and_type_index first_index

        def initialize(pool, data, start)
          super(pool, data, start)

          @bootstrap_method_attr_index = data.u2(start+1)
          @first_index = data.u2(start+3)
          @size = 5
        end
        alias name_and_type_value first_value
      end

      class ConstantModule < SingleReference # ZenTest SKIP
        alias name_index first_index
  
        def initialize(pool, data, start)
          super(pool, data, start)
        end
        alias name_value first_value
      end
  
      class ConstantPackage < SingleReference # ZenTest SKIP
        alias name_index first_index
  
        def initialize(pool, data, start)
          super(pool, data, start)
        end
        alias name_value first_value
      end
          
    end
  end
end