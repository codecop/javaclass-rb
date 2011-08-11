require File.dirname(__FILE__) + '/setup'
require 'javaclass/java_name_factory'

class TestJavaNameFactory < Test::Unit::TestCase

  def test_java
    assert_equal('java.lang.String', java.lang.String)
    assert_equal('java.lang.String', java.lang.String.full_name)
    assert_equal('java.lang', java.lang.*)
    assert_equal('java.lang', java.lang.*.package)
    assert_raise(NoMethodError) { java.long.Class }
    assert_raise(NoMethodError) { java.lang.Signal! }
  end

  def test_javax
    assert_equal('javax.xml.Document', javax.xml.Document)
  end

  def test_method_missing
    assert_equal('org.codecop.kata.PrimeFactors', org.codecop.kata.PrimeFactors)
    assert_raise(NoMethodError) { com.sun.Signal! }
    assert_raise(NameError) { xx.cmp.Signal }
  end

end
