module JavaClass # :nodoc:
  
  # The <code>CAFEBABE</code> magic of a class file.
  # Author::   Peter Kofler
  class ClassMagic
    
    CAFE_BABE = "\xCA\xFE\xBA\xBE"
    
    attr_reader :bytes
    
    # Check the class magic from the byte _data_ at position _start_ which is usually 0.
    def initialize(data, start=0)
      # "parsing"
      @bytes = data[start..start+3]
    end
    
    # Return true if the data was valid, i.e. if the class started with <code>CAFEBABE</code>.
    def valid?
      @bytes == CAFE_BABE
    end
    
  end
  
end
