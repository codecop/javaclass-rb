require File.dirname(__FILE__) + '/setup'
require 'javaclass/string_ux'

class TestString < Test::Unit::TestCase
  
  def test_string_u
    assert_equal(49, "1".u1(0))
    assert_equal(49, "212".u1(1))
    assert_equal(50, "212".u1(2))
    
    assert_equal(49*256+50, "12".u2(0))
    assert_equal(49*256+50, "312".u2(1))
  end
  
end
