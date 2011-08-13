require File.dirname(__FILE__) + '/setup'
require 'javaclass/dsl/java_name_factory'

module TestJavaClass
  module TestDsl

    class TestJavaNameFactory < Test::Unit::TestCase

      include JavaClass::Dsl::JavaNameFactory

      def test_java
        assert_equal('java.lang.String', java.lang.String)
        assert_equal('java.lang.String', java.lang.String.full_name)
        assert_equal('java.lang', java.lang.*)
        assert_equal('java.lang', java.lang.*.package)
      end

      def test_java_reserved_word
        assert_raise(NoMethodError) { java.long.Class }
      end

      def test_javax
        assert_equal('javax.xml.Document', javax.xml.Document)
      end

      def test_method_missing
        assert_equal('org.codecop.kata.PrimeFactors', org.codecop.kata.PrimeFactors)
      end

      def test_method_missing_no_java_identifier
        assert_raise(NoMethodError) { java.lang.Signal! }
        assert_raise(NoMethodError) { com.sun.Signal! }
      end

      def test_method_missing_no_iso_code
        assert_raise(NameError) { xx.cmp.Signal }
      end

    end

  end
end
