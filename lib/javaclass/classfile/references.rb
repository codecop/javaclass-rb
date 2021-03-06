require 'javaclass/classfile/constant_pool'

module JavaClass
  module ClassFile

    # Container class for list of all classes, methods and fields referenced by this class.
    # This information is derived from the constant pool, no analysis.
    # Author::   Peter Kofler
    class References

      # Create a references container with the constant _pool_ and skip references to index _classidx_ which is the host class itself.
      def initialize(pool, classidx)
        @constant_pool = pool
        @class_idx = classidx
      end

      # Return the constants referring to fields (Constants::ConstantField).
      # If _includeown_ is +true+ then fields of this class are returned also.
      def referenced_fields(includeown=false)
        @constant_pool.find(ConstantPool::FIELD_TAG).find_all do |field|
          includeown || field.class_index != @class_idx
        end
      end

      # Return the constants referring to methods (Constants::ConstantMethod) in classes or interfaces.
      # If _includeown_ is +true+ then methods of this class are returned also.
      def referenced_methods(includeown=false)
        @constant_pool.find(ConstantPool::METHOD_TAG, ConstantPool::INTERFACE_METHOD_TAG).find_all do |method|
          includeown || method.class_index != @class_idx
        end
      end

      # Return the list of all constant pool constantss containing class names of all used classes.
      # Returns a list of ConstantClass. 
      def used_classes
        my_class_name = @constant_pool[@class_idx].class_name
        @constant_pool.find(ConstantPool::CLASS_TAG).find_all do |cl|
          cl.class_name != my_class_name 
        end
      end

    end

  end
end
