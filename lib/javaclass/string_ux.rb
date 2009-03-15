# Add some +unpack+ helper methods for HI-LO byte orders contained in the String.
# Author::          Peter Kofler
class String
  
  # Return the _index_ 'th element as byte.
  def u1(index=0)
    self[index]
  end
  
  # Return the _index_ 'th and the next element as unsigned word in network byte order.
  def u2(index=0)
    self[index..index+1].unpack('n')[0]
    # same as self[index]*256 + self[index+1] 
  end
  
  # Return the _index_ 'th and the 3 next elements as unsigned dword in network byte order.
  def u4(index=0)
    self[index..index+3].unpack('N')[0]
  end
  
  # Return the _index_ 'th and the 7 next elements as unsigned qword in network byte order.
  def u8(index=0)
    u4(index) * 256**4 + u4(index+4)
  end
  
  # Return the _index_ 'th and the 3 next elements as single float in network byte order..
  # See::           http://steve.hollasch.net/cgindex/coding/ieeefloat.html
  # See::           http://blade.nagaokaut.ac.jp/cgi-bin/scat.rb/ruby/ruby-talk/196633
  def single(index=0)
    self[index..index+3].unpack('g')[0]
  end
  
  # Return the _index_ 'th and the 7 next elements as double float in network byte order.
  def double(index=0)
    self[index..index+7].unpack('G')[0]
  end
  
end
