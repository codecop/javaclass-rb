# Add some +hexdump+ helper method to dump the data contained in this String.
# Author::          Peter Kofler
class String

  # Each displayed number is 2 nibbles, i.e. it's a byte.
  NIBBLE_SIZE = 2
  NIBBLE_FORMAT_STR = "%#{NIBBLE_SIZE}.#{NIBBLE_SIZE}X "
  NIBBLE_WHITE_SPACE = ' ' * (NIBBLE_SIZE + 1)

  # Return the hex dump of this String with _columns_ columns of hexadecimal numbers per line.
  def hexdump(columns=16)
    return "#{format_address(0)}: #{NIBBLE_WHITE_SPACE*columns}; \n" if size == 0

    scan(/[\x00-\xff]{1,#{columns}}/).inject([0, []]) { |result, part|
      offset,previous_lines = *result

      formatted_address = format_address(offset)
      formatted_hexbytes = part.unpack('C' * part.size).collect{|c| format_byte(c) }
      space = NIBBLE_WHITE_SPACE * (columns - part.size)
      display = part.gsub(/[^ -\x7f]/, '.')
      line = "#{formatted_address}: #{formatted_hexbytes.join}#{space}; #{display}\n"

      [ offset + columns, previous_lines + [line] ]
    }[1].join
  end

  private

  # Format the number _address_ to a 8 digit hex number.
  def format_address(address)
    sprintf('%8.8Xh', address)
  end

  # Format the _bytes_ value to a +NIBBLE_SIZE+ digit hex number.
  def format_byte(byte)
    sprintf(NIBBLE_FORMAT_STR, byte)
  end

end
