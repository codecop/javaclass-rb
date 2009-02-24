require 'javaclass/string_ux'

module JavaClass # :nodoc:
  
  # Provide information of a Java class file header, like done by Javap. 
  # See::             http://java.sun.com/docs/books/jvms/second_edition/html/ClassFile.doc.html
  # Author::          Kugel, <i>Theossos Comp Group</i>
  class JavaClassHeader
    
    # Access flags as defined by JVM spec.
    ACC_PUBLIC = 0x0001    
    #ACC_FINAL = 0x0010    
    #ACC_SUPER = 0x0020    
    #ACC_INTERFACE = 0x0200    
    #ACC_ABSTRACT = 0x0400  
    
    # Create a new header with the binary _data_ from the class file _name_
    def initialize(name, data)
      
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
      
      @valid = data[0..3] == "\xCA\xFE\xBA\xBE"
      @minor_version = data.u2(4)
      #dump << "  minor version: #{@minor_version}" 
      @major_version = data.u2(6)
      #dump << "  major version: #{@major_version}" 
      
      #dump << "  Constant pool:" 
      constant_pool_count = data.u2(8)
      pos = 10
      cnt = 1
      while cnt <= constant_pool_count-1
        case data.u1(pos) # cp_info_tag
          
          when 7
          #dump << "const ##{cnt} = class 7 \t ##{data.u2(pos+1)}; \t // " 
          pos += 3
          
          when 9
          #dump << "const ##{cnt} = Field 9 \t ##{data.u2(pos+1)}.##{data.u2(pos+3)}; \t // " 
          pos += 5
          
          when 10
          #dump << "const ##{cnt} = Method 10 \t ##{data.u2(pos+1)}.##{data.u2(pos+3)}; \t // " 
          pos += 5
          
          when 11
          #dump << "const ##{cnt} = InterfaceMethodref 11 \t ##{data.u2(pos+1)}.##{data.u2(pos+3)}; \t // " 
          pos += 5
          
          when 8
          #dump << "const ##{cnt} = String 8 \t ##{data.u2(pos+1)}; \t // " 
          pos += 3
          
          when 3
          #dump << "const ##{cnt} = int 3 \t #{data.u4(pos+1)};" 
          pos += 5
          
          when 4
          #dump << "const ##{cnt} = float 4 \t #{data[pos+1..pos+4]};" 
          pos += 5
          
          when 5
          #dump << "const ##{cnt} = long 5 \t #{data.u8(pos+1)};" 
          pos += 9
          cnt += 1
          
          when 6
          #dump << "const ##{cnt} = double 6 \t #{data[pos+1..pos+8]};" 
          pos += 9
          cnt += 1
          
          when 12
          #dump << "const ##{cnt} = NameAndType 12 \t ##{data.u2(pos+1)}:##{data.u2(pos+3)}; \t // " 
          pos += 5
          
          when 1
          length = data.u2(pos+1)
          
          #value = data[pos+3..pos+3+length-1]
          #if value =~ /\.java$/
          #  dump.insert(0, "  SourceFile: \"#{value}\"")
          #  dump.insert(0, "Compiled from \"#{value}\"")
          #end
          #dump << "const ##{cnt} = Asciz 1 \t #{value};"
          
          pos += 3 + length
        else
          #puts dump.join("\n") 
          raise "const ##{cnt} = unknown constant pool tag #{data[pos]} at pos #{pos} in class #{name}"
        end
        cnt += 1
      end
      
      @access_flags = data.u2(pos)
    end
    
    # Return true if the data was valid, i.e. if the class started with <code>CAFEBABE</code>.
    def valid?
      @valid
    end
    
    # Return the class file version, like 48.0 (Java 1.4) or 50.0 (Java 6).
    def version
     "#{@major_version}.#{@minor_version}"
    end
    
    # Return true if the class is public.
    def accessible?
     (@access_flags & ACC_PUBLIC) != 0
    end
    
  end
  
end
