require 'javaclass/constant_pool'

module JavaClass
  
  # Container class for list of all classes, methods and fields referenced by this class.
  # Author::   Peter Kofler
  class References
    
    # Create a new references container with the constant _pool_ and skip references to _classidx_ which is the host class itself.  
    def initialize(pool, classidx)
      @constant_pool = pool
      @class_idx = classidx
    end
    
    # Return the constants referring to fields (+Constants::ConstantField+). 
    # If _includeown_ is +true+ then fields of this class are returned also. 
    def referenced_fields(includeown=false)
      @constant_pool.find(ConstantPool::FIELD_TAG).find_all { |field| includeown || field.class_index != @class_idx }
    end
    
    # Return the constants referring to methods (+Constants::ConstantMethod+) in classes or interfaces. 
    # If _includeown_ is +true+ then methods of this class are returned also. 
    def referenced_methods(includeown=false)
      @constant_pool.find(ConstantPool::METHOD_TAG, ConstantPool::INTERFACE_METHOD_TAG).find_all do |method| 
        includeown || method.class_index != @class_idx 
      end
    end
    
  end
  
end
