# Compatibility methods to work with Ruby 1.8, 1.9 and 2.0 Strings.
# Author::          Peter Kofler
class String

  RUBY19 = ''.respond_to? :codepoints 
  
  # Return the _index_'th element as byte.
  def byte_at(index=0)
    if RUBY19
      self[index..index].unpack('C')[0]
    else
      self[index]
    end
  end

  def same_bytes_as?(other)
    if RUBY19
      self.unpack('C*') == other.unpack('C*')
    else
      self == other
    end
  end
  
end
