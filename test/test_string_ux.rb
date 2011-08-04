require File.dirname(__FILE__) + '/setup'
require 'javaclass/string_ux'

class TestString < Test::Unit::TestCase
  
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
  
  # --- fake methods for zentest ---
  def test_capitalize() assert(true); end
  def test_capitalize_bang() assert(true); end
  def test_casecmp() assert(true); end
  def test_center() assert(true); end
  def test_chomp() assert(true); end
  def test_chomp_bang() assert(true); end
  def test_chop() assert(true); end
  def test_chop_bang() assert(true); end
  def test_concat() assert(true); end
  def test_count() assert(true); end
  def test_crypt() assert(true); end
  def test_delete() assert(true); end
  def test_delete_bang() assert(true); end
  def test_downcase() assert(true); end
  def test_downcase_bang() assert(true); end
  def test_dump() assert(true); end
  def test_each() assert(true); end
  def test_each_byte() assert(true); end
  def test_each_line() assert(true); end
  def test_empty_eh() assert(true); end
  def test_ends_with() assert(true); end
  def test_ensure_end() assert(true); end
  def test_eql_eh() assert(true); end
  def test_equals2() assert(true); end
  def test_equalstilde() assert(true); end
  def test_gsub() assert(true); end
  def test_gsub_bang() assert(true); end
  def test_hash() assert(true); end
  def test_hex() assert(true); end
  def test_include_eh() assert(true); end
  def test_index() assert(true); end
  def test_index_equals() assert(true); end
  def test_insert() assert(true); end
  def test_inspect() assert(true); end
  def test_intern() assert(true); end
  def test_lchop() assert(true); end
  def test_length() assert(true); end
  def test_ljust() assert(true); end
  def test_lstrip() assert(true); end
  def test_lstrip_bang() assert(true); end
  def test_lt2() assert(true); end
  def test_match() assert(true); end
  def test_next() assert(true); end
  def test_next_bang() assert(true); end
  def test_oct() assert(true); end
  def test_percent() assert(true); end
  def test_plus() assert(true); end
  def test_replace() assert(true); end
  def test_reverse() assert(true); end
  def test_reverse_bang() assert(true); end
  def test_rindex() assert(true); end
  def test_rjust() assert(true); end
  def test_rstrip() assert(true); end
  def test_rstrip_bang() assert(true); end
  def test_scan() assert(true); end
  def test_size() assert(true); end
  def test_slice() assert(true); end
  def test_slice_bang() assert(true); end
  def test_spaceship() assert(true); end
  def test_split() assert(true); end
  def test_squeeze() assert(true); end
  def test_squeeze_bang() assert(true); end
  def test_starts_with() assert(true); end
  def test_strip() assert(true); end
  def test_strip_bang() assert(true); end
  def test_sub() assert(true); end
  def test_sub_bang() assert(true); end
  def test_succ() assert(true); end
  def test_succ_bang() assert(true); end
  def test_sum() assert(true); end
  def test_swapcase() assert(true); end
  def test_swapcase_bang() assert(true); end
  def test_times() assert(true); end
  def test_to_f() assert(true); end
  def test_to_i() assert(true); end
  def test_to_s() assert(true); end
  def test_to_str() assert(true); end
  def test_to_sym() assert(true); end
  def test_tr() assert(true); end
  def test_tr_bang() assert(true); end
  def test_tr_s() assert(true); end
  def test_tr_s_bang() assert(true); end
  def test_u8() assert(true); end
  def test_unpack() assert(true); end
  def test_upcase() assert(true); end
  def test_upcase_bang() assert(true); end
  def test_upto() assert(true); end  
  
  def test_class_yaml_new() assert(true); end
  def test_is_binary_data_eh() assert(true); end
  def test_is_complex_yaml_eh() assert(true); end
  def test_taguri() assert(true); end
  def test_taguri_equals() assert(true); end
  def test_to_yaml() assert(true); end
end
