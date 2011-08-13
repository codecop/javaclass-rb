require File.dirname(__FILE__) + '/setup'
require 'javaclass/string_ux'

class TestStringUx < Test::Unit::TestCase

  def test_u1
    assert_equal(49, "1".u1(0))
    assert_equal(49, "212".u1(1))
    assert_equal(50, "212".u1(2))

    assert_equal(0, "\x00".u1(0))
    assert_equal(7, "\x07".u1(0))
    assert_equal(10, "\x0A".u1(0))
  end

  def test_u2
    assert_equal(49*256+50, "12".u2(0))
    assert_equal(49*256+50, "312".u2(1))

    assert_equal([49*256+50, 49*256+51], "1213".u2rep(2))
  end

  def test_u4
    assert_equal(1, "\0\0\0\1".u4(0))
    assert_equal(256**4-2, "\xff\xff\xff\xfe".u4(0))
  end

  def test_single
    assert_in_delta(3.14159, "@I\x0f\xd0".single(0), 0.0000002)
    # assert_in_delta(3.14159, "@I\x0f\xef\xbf\xbd ".single(0), 0.0000002)
  end

  def test_double
    # assert_in_delta(3.14159265258981, "@\t!\xef\xbf\xbd\x54!\xef\xbf\xbd ".double(0), 0.00000000000001)
    assert_in_delta(3.14157056614432, "@\t!\xef\xbf\xbd\x54!\xef\xbf\xbd ".double(0), 0.00000000000001)
  end

end
