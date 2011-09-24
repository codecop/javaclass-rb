require 'javaclass/string_ux'

module JavaClass
  module ClassFile

    # The module Constants is for separating namespaces. It contains the logic to parse constant pool constants.
    # Author::          Peter Kofler
    module Constants 

      # Superclass of all constant values in the constant pool. Every constant has a +name+, a +tag+ and a +size+ in bytes.
      # Author::   Peter Kofler
      class Base # ZenTest FULL to find method name

        attr_reader :name
        attr_reader :tag
        attr_reader :size
        attr_reader :slots

        # Set default constants.
        def initialize(name=nil)
          @name = self.class.to_s[/::[^:]+$/][10..-1] # skip modules (::) and "Constant"
          @name = name if name
          @size = 3
          @slots = 1
        end

        # Return part of debug output.
        def dump
          "#{@name}\t" # #{@tag}
        end

        # Return false for sanity check if it's a class. Subclasses should overwrite.
        def const_class?
          false
        end

        # Return false for sanity check if it's a field. Subclasses should overwrite.
        def const_field?
          false
        end

        # Return false for sanity check if it's a method. Subclasses should overwrite.
        def const_method?
          false
        end

      end

    end
  end
end
