require 'javaclass/string_ux'
require 'javaclass/classfile/class_magic'
require 'javaclass/classfile/class_version'
require 'javaclass/classfile/constant_pool'
require 'javaclass/classfile/class_access_flags'
require 'javaclass/classfile/fields'
require 'javaclass/classfile/methods'
require 'javaclass/classfile/attributes/attributes'
require 'javaclass/classfile/class_file_attributes'
require 'javaclass/classfile/references'
require 'javaclass/java_name'

module JavaClass

  # The module ClassFile is for separating namespaces. It contains the logic 
  # to parse a Java class file. This logic is tied to the JVM specification
  # of class files, very low-level and has no usage/DSL features.
  # The main entry point is JavaClassHeader. It's the only "public" class
  # of the module, so the only class to require from outside.
  # Author::          Peter Kofler
  module ClassFile

    # Parse and disassemble Java class files, similar to the +javap+ command.
    # Provides all information of a Java class file. This is just a container for all kind of
    # specialised elements. The constuctor parses and creates all contained elements.
    # See::             https://docs.oracle.com/javase/specs/jvms/se8/html/jvms-4.html
    # See::             {en.wikipedia.org/wiki/Class}[http://en.wikipedia.org/wiki/Class_(file_format)]
    # Author::          Peter Kofler
    class JavaClassHeader

      attr_reader :magic
      attr_reader :version
      attr_reader :constant_pool
      attr_reader :access_flags
      attr_reader :references
      attr_reader :interfaces
      attr_reader :attributes

      # Create a header with the binary _data_ from the class file.
      def initialize(data)
        pos = 0

        #  ClassFile {
        #    u4 magic; 
        @magic = ClassMagic.new(data)
        pos += 4

        #    u2 minor_version;
        #    u2 major_version;
        @version = ClassVersion.new(data)
        pos += 4

        #    u2 constant_pool_count;
        #    cp_info constant_pool[constant_pool_count-1];
        @constant_pool = ConstantPool.new(data)
        pos += @constant_pool.size

        #    u2 access_flags;
        @access_flags = ClassAccessFlags.new(data.u2(pos))
        pos += 2

        #    u2 this_class;
        @this_class_idx = data.u2(pos)
        pos += 2

        #    u2 super_class;
        @super_class_idx = data.u2(pos)
        pos += 2

        #    u2 interfaces_count;
        #    u2 interfaces[interfaces_count];
        count = data.u2(pos)
        @interfaces = data.u2rep(count, pos + 2).collect { |i| @constant_pool.class_item(i) }
        pos += 2 + count*2

        #    u2 fields_count;
        #    field_info fields[fields_count];
        @fields = Fields.new(data, pos, @constant_pool)
        pos += @fields.size
        
        #    u2 methods_count;
        #    method_info methods[methods_count];
        @methods = Methods.new(data, pos, @constant_pool)
        pos += @methods.size

        #    u2 attributes_count;
        #    attribute_info attributes[attributes_count];
        attr = Attributes::Attributes.new(data, pos, @constant_pool)
        pos += attr.size
        @attributes =  ClassFileAttributes.new(attr, this_class)
         
        #  }
        @references = References.new(@constant_pool, @this_class_idx)
        
        #  Body {
        # Class: add the byte code sequences to the methods so it can be analysed later (see JVM spec)
        #  }

      end

      # Return the name of this class. Returns a JavaVMName.
      def this_class
        # This is a ConstantClass entry in the constant pool.
        @jvmname ||= @constant_pool.class_item(@this_class_idx).class_name 
      end

      # Return the name of the superclass of this class or +nil+. Returns a JavaVMName.
      def super_class
        if @super_class_idx > 0
          # This is a ConstantClass entry in the constant pool.
          @constant_pool.class_item(@super_class_idx).class_name
        else
          # special case: java.lang.Object has no superclass 
          nil
        end
      end

      # Return a debug output of this class that looks similar to +javap+ output.
      def dump
        d = []
        mod = @access_flags.public? ? 'public ' : ''
        ext = super_class ? " extends #{super_class.to_classname}" : ''
        int = !@interfaces.empty? ? " implements #{@interfaces.join(',')}" : ''
        d << "#{mod}class #{this_class.to_classname}#{ext}#{int}"
        d << "  SourceFile: \"#{attributes.source_file}\""
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