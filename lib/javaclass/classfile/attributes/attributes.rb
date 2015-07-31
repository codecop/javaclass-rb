module JavaClass
  module ClassFile
    module Attributes

      # General container of the attributes.
      # Author::   Peter Kofler
      class Attributes

        # Size of the whole attributes structure in bytes.
        attr_reader :size

        # Parse the attributes structure from the bytes _data_ beginning at position _start_.
        def initialize(data, start, constant_pool)
          creator = AttributesCreator.new(data, start, constant_pool)
          creator.create!
          @attributes = creator.attributes
          @size = creator.size
        end

        # Find the attribute with the given _name_.
        def with(name)
          @attributes.find { |attr|  attr.name == name  }
        end

      end

      class AttributesCreator # :nodoc:

        attr_reader :attributes

        def initialize(data, start, constant_pool)
          @data = data
          @start = start
          @pos = start
          @constant_pool = constant_pool
        end

        def size
          @pos - @start
        end

        def create!
          @attributes = []

          count = @data.u2(@pos)
          @pos += 2

          (1..count).each do |i|
            attribute_name_idx = @data.u2(@pos) 
            @pos += 2
            attribute_name = @constant_pool[attribute_name_idx].string

            attribute_length = @data.u4(@pos)
            @pos += 4
            
            if attribute_name == 'SourceFile'
              @attributes << source_file(attribute_name)
            elsif attribute_name == 'InnerClasses'
              @attributes << inner_classes(attribute_name)
            else # skip 
              @pos += attribute_length 
            end

          end
        end

        def source_file(attribute_name)
          sourcefile_idx = @data.u2(@pos)
          @pos += 2
          source_file = @constant_pool[sourcefile_idx].string
          SourceFile.new(attribute_name, source_file)
        end

        def inner_classes(attribute_name)
          number_of_classes = @data.u2(@pos)
          @pos += 2
          inner_classes = (1..number_of_classes).collect do |i|
            inner_class_info_idx = @data.u2(@pos)
            @pos += 2
            
            @pos += 4
            inner_class_access_flags = @data.u2(@pos)
            @pos += 2

            inner_class_info = @constant_pool[inner_class_info_idx]

            InnerClass.new(inner_class_info.class_name, AccessFlags.new(inner_class_access_flags))
          end
          InnerClasses.new(attribute_name, inner_classes)
        end

      end

      # Base class of the attributes
      # Author::   Peter Kofler
      class Attribute
        attr_reader :name

        def initialize(name)
          @name = name
        end
      end

      class SourceFile < Attribute
        attr_reader :source_file

        def initialize(name, source_file)
          super(name)
          @source_file = source_file
        end
      end

      class InnerClasses < Attribute
        attr_reader :inner_classes

        def initialize(name, inner_classes)
          super(name)
          @inner_classes = inner_classes
        end
      end

      class InnerClass
        attr_reader :class_name
        attr_reader :access_flags

        def initialize(name, access_flags)
          @class_name = name
          @access_flags = access_flags
        end
      end

    end
  end
end
