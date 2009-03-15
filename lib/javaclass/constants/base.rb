require 'javaclass/string_ux'

module JavaClass # :nodoc:
  module Constants # :nodoc:
    
    # Superclass of constant values in the constant pool. Every constant has a name, a tag and a size.
    # Author::   Peter Kofler
    class Base
      
      attr_reader :name
      attr_reader :cp_info_tag
      attr_reader :size
      attr_reader :slots
      
      # Set default constants.
      def initialize(name=nil)
        @name = self.class.to_s[/::[^:]+$/][10..-1] # skip modules (::) and "Constant"
        @name = name if name
        @size = 3
        @slots = 1
      end
      
      def dump
        "#{@name}\t" # #{@cp_info_tag} 
      end
      
    end
    
  end
end
