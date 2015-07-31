module JavaClass
  module ClassFile
    module Attributes

      # Container of the attributes.
      # Author::   Peter Kofler
      class Attributes

        # Size of the whole attributes structure in bytes.
        attr_reader :size
        # Return the number of attributes.
        attr_reader :count

        # Parse the attributes structure from the bytes _data_ beginning at position _start_.
        def initialize(data, start, constant_pool)
          @count = data.u2(start)
          @size = 2

          @attributes = []
          # TODO move builder out like in constant pool
          (1..@count).each do |i|
            attribute_name_index = data.u2(start + @size) # later ... get from ConstantPool
            @size += 2
            attribute_length = data.u4(start + @size)
            @size += 4
            pos = @size
            @size += attribute_length # skip for now

            attribute_name = constant_pool[attribute_name_index].string
            if attribute_name == 'SourceFile'
              sourcefile_index = data.u2(start + pos)
              source_file = constant_pool[sourcefile_index].string
              @attributes << SourceFile.new(attribute_name, source_file)
            elsif attribute_name == 'InnerClasses'
              number_of_classes = data.u2(start + pos)
              pos += 2
              inner_classes = (1..number_of_classes).collect do |i|
                inner_class_info_index = data.u2(start + pos)
                pos += 8
                inner_class_info = constant_pool[inner_class_info_index]
                inner_class_info.class_name
              end
              @attributes << InnerClasses.new(attribute_name, inner_classes)
            end

          end
        end

        def with(name)
          @attributes.find { |attr|
            attr.name == name
          }
        end

      end

      class SourceFile
        attr_reader :name
        attr_reader :source_file

        def initialize(name, source_file)
          @name = name
          @source_file = source_file
        end
      end

      class InnerClasses
        attr_reader :name
        attr_reader :inner_classes

        def initialize(name, inner_classes)
          @name = name
          @inner_classes = inner_classes
        end
      end

    end
  end
end
