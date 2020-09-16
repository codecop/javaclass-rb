require File.dirname(__FILE__) + '/setup'
require 'javaclass/string_hexdump'

class TestStringHexdump < Test::Unit::TestCase

  def test_hexdump_empty
    assert_equal("00000000h: #{'   '*16}; \n", ''.hexdump)
  end

  def test_hexdump_line
    assert_equal("00000000h: 61 #{'   '*15}; a\n", 'a'.hexdump)
  end

  def test_hexdump_non_printable
    assert_equal("00000000h: 01 02 03 04 05 06 07 08 09 0A #{'   '*6}; ..........\n", "\x01\x02\x03\x04\x05\x06\x07\x08\x09\x0a".hexdump)
    assert_equal("00000000h: FF FE FC #{'   '*13}; ...\n", "\xff\xfe\xfc".hexdump)
  end

  def test_hexdump_more_lines
    assert_equal("00000000h: 00 00 ; ..\n00000002h: 00 00 ; ..\n", "\x00\x00\x00\x00".hexdump(2));
  end

  def test_hexdump_whitespace
    assert_equal("00000000h: 20 00 65 00 #{'   '*12};  .e.\n", " \x00e\x00".hexdump);
  end

end
