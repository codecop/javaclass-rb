require 'javaclass/string_ux'
require 'javaclass/classfile/class_magic'
require 'javaclass/classfile/class_version'
require 'javaclass/classfile/constant_pool'
require 'javaclass/classfile/references'
require 'javaclass/classfile/access_flags'
require 'javaclass/java_class_name'

module JavaClass 
  module ClassFile # :nodoc:
    
    # Provide all information of a Java class file. This is just a container for all kind of
    # specialised elements. The constuctor parses and creates all contained elements. 
    # See::             http://java.sun.com/docs/books/jvms/second_edition/html/ClassFile.doc.html
    # See::             {en.wikipedia.org/wiki/Class}[http://en.wikipedia.org/wiki/Class_(file_format)]
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
        #    u4 magic; - ok
        #    u2 minor_version; - ok
        #    u2 major_version; - ok
        #    u2 constant_pool_count; - ok
        #    cp_info constant_pool[constant_pool_count-1]; - ok
        #    u2 access_flags; - ok
        #    u2 this_class; - ok
        #    u2 super_class; - ok
        # TODO implement function for fields and methods (JVM spec)
        #    u2 interfaces_count;
        #    u2 interfaces[interfaces_count];
        #    u2 fields_count;
        #    field_info fields[fields_count];
        #    u2 methods_count;
        #    method_info methods[methods_count];
        #    u2 attributes_count;
        #    attribute_info attributes[attributes_count];
        #  }
        # TODO Java 1.0 - "private protected" fields.
        
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
        @constant_pool[@this_class_idx].to_s.to_classname
      end
      
      # Return the name of the superclass of this class or +nil+.
      def super_class
        if @super_class_idx>0
          @constant_pool[@super_class_idx].to_s.to_classname
        else
          nil
        end
      end
      
      # Return a debug output of this class that looks similar to +javap+ output.
      def dump
        d = []
        if @access_flags.public?
          mod = 'public ' 
        else
          mod = ''
        end
        d << "#{mod}class #{this_class} extends #{super_class}"
        # d << "  SourceFile: \"#{read from LineNumberTable?}\""
        d += @version.dump 
        d += @constant_pool.dump
        d << ''
        d << '{'
        d << '}'
        d
      end
      
    end
    
  end
end