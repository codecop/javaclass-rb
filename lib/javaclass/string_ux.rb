# Add some +unpack+ helper methods for HI-LO byte order (network byte order) contained in this String.
# Author::          Peter Kofler
class String

  RUBY19 = ''.respond_to? :codepoints 
  
  # Return the _index_'th element as byte.
  def u1(index=0)
    if RUBY19
      self[index..index].unpack('C')[0]
    else
      self[index]
    end
  end

  # Return the _index_'th and the next element as unsigned word.
  def u2(index=0)
    self[index..index+1].unpack('n')[0]
    # self[index]*256 + self[index+1]
  end

  # Return the _index_'th and the next element as unsigned word, repeat it for _count_
  # words in total and return an array of these words.
  def u2rep(count=1, index=0)
    self[index...index+count*2].unpack('n'*count)
  end

  # Return the _index_'th and the next 3 elements as unsigned dword.
  def u4(index=0)
    self[index..index+3].unpack('N')[0]
  end

  # Return the _index_'th and the next 7 elements as unsigned qword.
  def u8(index=0)
    u4(index) * 256**4 + u4(index+4)
  end

  # Return the _index_'th and the next 3 elements as single precision float.
  # See::           http://steve.hollasch.net/cgindex/coding/ieeefloat.html
  # See::           http://blade.nagaokaut.ac.jp/cgi-bin/scat.rb/ruby/ruby-talk/196633
  def single(index=0)
    self[index..index+3].unpack('g')[0]
  end

  # Return the _index_'th and the next 7 elements as double precision float.
  def double(index=0)
    self[index..index+7].unpack('G')[0]
  end

  def same_bytes?(other)
    if RUBY19
      self.unpack('C*') == other.unpack('C*')
    else
      self == other
    end
  end
  
end
