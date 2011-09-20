require 'javaclass/string_ux'
require 'javaclass/classfile/class_magic'
require 'javaclass/classfile/class_version'
require 'javaclass/classfile/constant_pool'
require 'javaclass/classfile/references'
require 'javaclass/classfile/access_flags'
require 'javaclass/java_name'

module JavaClass

  # The module ClassFile is for separating namespaces. It contains the logic 
  # to parse a Java class file. This logic is tied to the JVM specification
  # of class files, very low-level and has no usage/DSL features.
  # The main entry point is +JavaClassHeader+. It's the only "public" class
  # of the module, so the only class to require from outside.
  # Author::          Peter Kofler
  module ClassFile

    # Parse and disassemble Java class files, similar to the +javap+ command.
    # Provides all information of a Java class file. This is just a container for all kind of
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
      attr_reader :interfaces

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
        #    u2 interfaces_count;
        #    u2 interfaces[interfaces_count];
        # TODO implement fields and methods (see JVM spec)
        #    u2 fields_count;
        #    field_info fields[fields_count];
        #    u2 methods_count;
        #    method_info methods[methods_count];
        #    u2 attributes_count;
        #    attribute_info attributes[attributes_count];
        #  }
        #  Body {
        # TODO add the byte code sequences to the methods so it can be analysed later (see JVM spec)
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

        count = data.u2(pos)
        @interfaces = data.u2rep(count, pos + 2).collect { |i| @constant_pool.class_item(i) }
        pos += 2 + count*2

        #        count = data.u2(pos)
        #        @fields = data.u2rep(count, pos + 2).collect { |i| @constant_pool.field_item(i) }
        #        pos += 2 + count*2

        #        count = data.u2(pos)
        #        @methods = data.u2rep(count, pos + 2).collect { |i| @constant_pool.method_item(i) }
        #        pos += 2 + count*2
      end

      # Return the name of this class.
      def this_class
        @constant_pool.class_item(@this_class_idx).to_s.to_javaname
      end

      # Return the name of the superclass of this class or +nil+.
      def super_class
        if @super_class_idx > 0
          @constant_pool.class_item(@super_class_idx).to_s.to_javaname
        else
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
        # d << "  SourceFile: \"#{read from LineNumberTable?}\""
        d += @version.dump
        d += @constant_pool.dump
        d << ''
        d << '{'
        d << '}'
        d
      end

      # Return the qualified Java class name. This is a shortcut method and just delegates.
      def name
        this_class.full_name
      end

    end

  end
end