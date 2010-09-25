module JavaClass
  module ClassFile 
    
    # The +CAFEBABE+ magic of a class file. This just checks if CAFEBABE is here.
    # Author::   Peter Kofler
    class ClassMagic
      
      CAFE_BABE = "\xCA\xFE\xBA\xBE"
      
      # Check the class magic in the _data_ beginning at position _start_ (which is usually 0).
      def initialize(data, start=0)
        # "parsing"
        @bytes = data[start..start+3]
      end
      
      # Return +true+ if the data was valid, i.e. if the class started with +CAFEBABE+.
      def valid?
        @bytes == CAFE_BABE
      end
      
      # Return the value of the magic in this class.
      def bytes
        @bytes.dup
      end
      
    end
    
  end
end