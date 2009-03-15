# Add some +unpack+ helper methods for HI-LO byte orders contained in the String.
# Author::          Peter Kofler
class String
  
  # Return the _index_ 'th element as byte.
  def u1(index)
    self[index]
  end
  
  # Return the _index_ 'th and the next element as unsigned word.
  def u2(index)
    self[index..index+1].unpack('n')[0]
    # same as self[index]*256 + self[index+1] 
  end
  
  # Return the _index_ 'th and the 3 next elements as unsigned dword.
  def u4(index)
    self[index..index+3].unpack('N')[0]
  end
  
  # Return the _index_ 'th and the 7 next elements as unsigned qword.
  def u8(index)
    u4(index) * 256**4 + u4(index+4)
  end
  
end
