require 'javaclass/string_ux'
require 'javaclass/class_magic'
require 'javaclass/class_version'
require 'javaclass/constant_pool'

module JavaClass 
  
  # Provide all information of a Java class file. 
  # Author::          Peter Kofler
  class JavaClassHeader
    
    # Access flags as defined by JVM spec.
    ACC_PUBLIC = 0x0001    
    ACC_FINAL = 0x0010    
    ACC_SUPER = 0x0020    
    ACC_INTERFACE = 0x0200    
    ACC_ABSTRACT = 0x0400  
    
    attr_reader :magic    
    attr_reader :version
    attr_reader :constant_pool
    # Name of this class.
    attr_reader :this_class
    # Name of the superclass of this class or +nil+.
    attr_reader :super_class
    
    # Create a header with the binary _data_ from the class file.
    def initialize(data)
      
      #  ClassFile {
      #    u4 magic;
      #    u2 minor_version;
      #    u2 major_version;
      #    u2 constant_pool_count;
      #    cp_info constant_pool[constant_pool_count-1];
      #    u2 access_flags;
      #    u2 this_class;
      #    u2 super_class;
      #    u2 interfaces_count;
      #    u2 interfaces[interfaces_count];
      #    u2 fields_count;
      #    field_info fields[fields_count];
      #    u2 methods_count;
      #    method_info methods[methods_count];
      #    u2 attributes_count;
      #    attribute_info attributes[attributes_count];
      #  }
      
      @magic = ClassMagic.new(data)
      @version = ClassVersion.new(data)
      
      @constant_pool = ConstantPool.new(data)
      pos = 8 + @constant_pool.size
      
      @access_flags = data.u2(pos)
      pos += 2
      # TODO make own class for AccessFlags and provide all methods to query it together with constants
      
      idx = data.u2(pos)
      pos += 2
      @this_class = @constant_pool[idx].to_s
      
      idx = data.u2(pos)
      pos += 2
      @super_class = nil
      @super_class = @constant_pool[idx].to_s if idx>0
    end
    
    # Return +true+ if the class is public.
    def accessible?
     (@access_flags & ACC_PUBLIC) != 0
    end
    
    # Return a debug output of this class that looks similar to +javap+ output.
    def dump
      d = []
      # dump << "  SourceFile: \"#{@value}\""
      # dump << "Compiled from \"#{@value}\""
      d += @version.dump 
      d += @constant_pool.dump
      d
    end
    
  end
  
end
