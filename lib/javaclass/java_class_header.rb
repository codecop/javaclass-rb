require 'javaclass/string_ux'
require 'javaclass/class_magic'
require 'javaclass/class_version'
require 'javaclass/constant_pool'

module JavaClass # :nodoc:
  
  # Provide information of a Java class file header, like done by Javap. 
  # See::             http://java.sun.com/docs/books/jvms/second_edition/html/ClassFile.doc.html
  # See::             http://en.wikipedia.org/wiki/Class_(file_format)
  # Author::          Peter Kofler
  class JavaClassHeader
    
    # Access flags as defined by JVM spec.
    ACC_PUBLIC = 0x0001    
    #ACC_FINAL = 0x0010    
    #ACC_SUPER = 0x0020    
    #ACC_INTERFACE = 0x0200    
    #ACC_ABSTRACT = 0x0400  
    
    # Return true if the data was valid, i.e. if the class started with <code>CAFEBABE</code>.
    attr_reader :magic    
    # Return the class file version, like 48.0 (Java 1.4) or 50.0 (Java 6).
    attr_reader :version
    
    attr_reader :constant_pool
    
    # Create a new header with the binary _data_ from the class file.
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
      
      #dump = []
      
      @magic = ClassMagic.new(data)
      @version = ClassVersion.new(data)
      #dump += << @version.dump 
      
      @constant_pool = ConstantPool.new(data)
      #dump += << @constant_pool.dump 
      pos = 8 + @constant_pool.size
      
      @access_flags = data.u2(pos)
    end
    
    # Return true if the class is public.
    def accessible?
     (@access_flags & ACC_PUBLIC) != 0
    end
    
  end
  
end
