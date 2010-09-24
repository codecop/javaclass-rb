require 'javaclass/string_ux'
require 'javaclass/classfile/class_magic'
require 'javaclass/classfile/class_version'
require 'javaclass/classfile/constant_pool'
require 'javaclass/classfile/references'
require 'javaclass/classfile/access_flags'

module JavaClass 
  module ClassFile # :nodoc:
    
    # Provide all information of a Java class file. This is just a container for all kind of
    # specialised elements. 
    # Author::          Peter Kofler
    class JavaClassHeader
      
      attr_reader :magic    
      attr_reader :version
      attr_reader :constant_pool
      attr_reader :access_flags
      attr_reader :references
      
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
        
        @access_flags = AccessFlags.new(data, pos)
        pos += 2
        
        idx = data.u2(pos)
        pos += 2
        @this_class_idx = idx
        
        @references = References.new(@constant_pool, @this_class_idx)
        
        idx = data.u2(pos)
        pos += 2
        @super_class_idx = idx
      end
      
      # Return the name of this class.
      def this_class
        @constant_pool[@this_class_idx].to_s
      end
      
      # Return the name of the superclass of this class or +nil+.
      def super_class
        if @super_class_idx>0
          @constant_pool[@super_class_idx].to_s
        else
          nil
        end
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
end