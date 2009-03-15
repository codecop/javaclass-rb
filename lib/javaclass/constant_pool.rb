require 'javaclass/string_ux'

module JavaClass # :nodoc:
  
  # Superclass of constant value classes.
  # Author::   Peter Kofler
  class ConstantBase
    
    attr_reader :name
    attr_reader :cp_info_tag
    attr_reader :size
    attr_reader :slots
    
    def initialize(name=nil)
      # default constants
      @name = self.class.to_s[19..-1]
      @name = name if name
      @size = 3
      @slots = 1
    end
    
    # Define a value _intotag_ withe _size_ and _slots_
    def value(infotag, size=5, slots=1)
      @cp_info_tag = infotag
      @size = size
      @slots = slots
    end
    
    # Define a single reference into _pool_ from _data_ beginning at _start_
    def single_ref(pool, data, start)
      @enclosing_pool = pool
      @cp_info_tag = data.u1(start)
      
      data.u2(start+1)
    end
    
    # Define a double reference into _pool_ from _data_ beginning at _start_
    def double_ref(pool, data, start)
      one = single_ref(pool, data, start)
      @size = 5
      
      [one, data.u2(start+3)]
    end
    
    def get(ref)
      @enclosing_pool[ref].to_s
    end
    
    def dump
      "#{@name} #{@cp_info_tag} \t" 
    end
  end
  
  class ConstantClass < ConstantBase
    def initialize(pool, data, start)
      super("class")
      @name_index = single_ref(pool, data, start)
    end
    def to_s
      get(@name_index)
    end
    def dump
      super + "##{@name_index}; \t // #{to_s}"
    end
  end
  
  class ConstantField < ConstantBase
    def initialize(pool, data, start) 
      super()
      @class_index, @name_and_type_index = double_ref(pool, data, start)
    end  
    def to_s
      "#{get(@class_index)}.#{get(@name_and_type_index)}"
    end
    def dump
      super + "##{@class_index}.##{@name_and_type_index}; \t // #{to_s}"
    end
  end
  
  class ConstantMethod < ConstantBase
    def initialize(pool, data, start) 
      super()
      @class_index, @name_and_type_index = double_ref(pool, data, start)
    end  
    def to_s
      "#{get(@class_index)}.#{get(@name_and_type_index)}"
    end
    def dump
      super + "##{@class_index}.##{@name_and_type_index}; \t // #{to_s}"
    end
  end
  
  class ConstantInterfaceMethod < ConstantBase
    def initialize(pool, data, start) 
      super()
      @class_index, @name_and_type_index = double_ref(pool, data, start)
    end  
    def to_s
      "#{get(@class_index)}.#{get(@name_and_type_index)}"
    end
    def dump
      super + "##{@class_index}.##{@name_and_type_index}; \t // #{to_s}"
    end
  end
  
  class ConstantString < ConstantBase
    def initialize(pool, data, start) 
      super()
      @string_index = single_ref(pool, data, start)
    end
    def to_s
      get(@string_index)
    end
    def dump
      super + "##{@string_index}; \t // #{to_s}"
    end
  end
  
  class ConstantInteger < ConstantBase
    def initialize(pool, data, start) 
      super("int")
      value(data.u1(start), 5)
      @value = data.u4(start+1)
    end
    def to_s
      @value.to_s
    end
    def dump
      super + "#{@value};"
    end
  end
  
  class ConstantFloat < ConstantBase
    def initialize(pool, data, start) 
      super("float")
      value(data.u1(start), 5) 
      @bytes = data[start+1..start+4] # ieee decoding?
    end
    def dump
      super + "#{@bytes};"
    end
  end
  
  class ConstantLong < ConstantBase
    def initialize(pool, data, start) 
      super("long")
      value(data.u1(start), 9, 2)
      @value = data.u8(start+1)
    end
    def dump
      super + "#{@value};"
    end
  end
  
  class ConstantDouble < ConstantBase
    def initialize(pool, data, start) 
      super("double")
      value(data.u1(start), 9, 2) 
      @bytes = data[start+1..start+8]
    end
    def to_s
      @bytes
    end
    def dump
      super + "#{@bytes};"
    end
  end
  
  class ConstantNameAndType < ConstantBase
    def initialize(pool, data, start)
      super()
      @name_index, @descriptor_index = double_ref(pool, data, start)
    end  
    def to_s
      "#{get(@name_index)}:#{get(@descriptor_index)}"
    end
    def dump
      super + "##{@name_index}:##{@descriptor_index}; \t // #{to_s}"
    end
  end
  
  class ConstantAsciz < ConstantBase
    def initialize(pool, data, start) 
      super()
      @cp_info_tag = data.u1(start)
      @length = data.u2(start+1)
      @size = 3 + @length
      @value = data[start+3..start+3+@length-1]
      #if @value =~ /\.java$/
      #  dump.insert(0, "  SourceFile: \"#{@value}\"")
      #  dump.insert(0, "Compiled from \"#{@value}\"")
      #end
    end
    def to_s
      @value
    end
    def dump
      super + "#{@value};"
    end
  end
  
  # Container of the constant pool.
  # Author::   Peter Kofler
  class ConstantPool
    
    # Types of constant pool constants.
    CONSTANT_TYPES = {
      7 => ConstantClass, 9 => ConstantField, 10 => ConstantMethod, 11 => ConstantInterfaceMethod, 8 => ConstantString, 
      3 => ConstantInteger, 4 => ConstantFloat, 5 => ConstantLong, 6 => ConstantDouble, 12 => ConstantNameAndType, 1 => ConstantAsciz,
    }
    
    # The size in bytes of this constant pool.
    attr_reader :size
    attr_reader :pool
    
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
    
    # Return a debug dump of this version.
    def dump
      ["  Constant pool:"]+ @pool.keys.sort.collect { |k| "const ##{k} = #{@pool[k].dump}"}
    end
    
  end

  # TODO verschiedene Klassen vereinfachen, damit nicht redundant ist
  # Tests für den Pool schreiben mit verschiedenen Varianten
  # Ieee Math Werte Double und Float umrechnen?

end

