# Add some +hexdump+ helper method to dump the data contained in this string.
# Author::          Peter Kofler
class String
  
  # Return the hex dump of this string with _columns_ columns per line.
  def hexdump(columns=16)
    scan(/[\x00-\xff]{1,#{columns}}/).inject([0, []]) { |result, part|
      current_address,previous_lines = *result

      formatted_address = sprintf('%8.8Xh', current_address)
      formatted_hexbytes = part.unpack('C' * part.size).collect{|c| sprintf('%2.2X ', c) }
      space = '   '*(columns-part.size)
      display = part.gsub(/[^ -\x7f]/, '.')
      line = "#{formatted_address}: #{formatted_hexbytes.join}#{space}; #{display}\n"

      [ current_address + columns, previous_lines + [line] ]
    }[1].join
  end

end
