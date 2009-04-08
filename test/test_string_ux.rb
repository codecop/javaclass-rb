require File.dirname(__FILE__) + '/setup'
require 'javaclass/string_ux'

class TestString < Test::Unit::TestCase
  
  def test_u1
    assert_equal(49, "1".u1(0))
    assert_equal(49, "212".u1(1))
    assert_equal(50, "212".u1(2))
  end
  
  def test_u2
    assert_equal(49*256+50, "12".u2(0))
    assert_equal(49*256+50, "312".u2(1))
  end
  
  def test_u4
    assert_equal(1, "\0\0\0\1".u4(0))
    assert_equal(256**4-2, "\xff\xff\xff\xfe".u4(0))
  end
  
  def test_single
    assert_in_delta(3.14159, '@I�'.single(0), 0.0000002) 
  end
  
  def test_double
    assert_in_delta(3.14159265258981, "@\t!�T!� ".double(0), 0.00000000000001) 
  end
  
end