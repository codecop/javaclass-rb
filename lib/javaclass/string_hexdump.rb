# Add some +hexdump+ helper method to dump the data contained in this String.
# Author::          Peter Kofler
class String

  # Return the hex dump of this String with _columns_ columns of hexadecimal numbers per line.
  def hexdump(columns=16)
    return StringLineHexdumper.empty(columns).format if size == 0

    input = [0, []]
    output = scan(/[\x00-\xff]{1,#{columns}}/).inject(input) { |result, part|
      offset, previous_lines = *result

      line = StringLineHexdumper.new(offset, columns, part).format
      
      [ offset + columns, previous_lines + [line] ]
    }
    offset, lines = *output
    lines.join
  end

end

# Dump a line of text as hex dump.
# Author::          Peter Kofler
class StringLineHexdumper 

  # Each displayed number is 2 nibbles, i.e. it's a byte.
  NIBBLE_SIZE = 2
  NIBBLE_FORMAT_STR = "%#{NIBBLE_SIZE}.#{NIBBLE_SIZE}X "
  NIBBLE_WHITE_SPACE = ' ' * (NIBBLE_SIZE + 1)

  # Factory method to create a formatter for an empty line with _columns_ length.
  def self.empty(columns)
    StringLineHexdumper.new(0, columns, '')
  end
  
  def initialize(address, columns, data)
    @address = address
    @maxlen = columns
    @data = data
  end

  def format
    address = format_address
    hexbytes = format_bytes
    space = add_whitespace
    display = strip_non_printable
    
    "#{address}: #{hexbytes.join}#{space}; #{display}\n"
  end

  private
  
  # Format the address to a 8 digit hex number.
  def format_address
    sprintf('%8.8Xh', @address)
  end

  def format_bytes
    @data.unpack('C' * @data.size).collect{ |c| format_byte(c) }
  end

  # Format the _bytes_ value to a +NIBBLE_SIZE+ digit hex number.
  def format_byte(byte)
    sprintf(NIBBLE_FORMAT_STR, byte)
  end

  def add_whitespace
    NIBBLE_WHITE_SPACE * (@maxlen - @data.size)
  end

  def strip_non_printable
    @data.gsub(/[^ -\x7f]/, '.')
  end
  
end
