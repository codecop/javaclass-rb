require File.dirname(__FILE__) + '/setup'
require 'javaclass/dsl/loading_classpath'
require 'javaclass/classpath/composite_classpath'

module TestJavaClass
  module TestDsl

    class TestLoadDirective < Test::Unit::TestCase
      extend JavaClass::Dsl::LoadDirective

      def create_1
        JavaClass::Classpath::CompositeClasspath.new('1')
      end

      def create_2
        JavaClass::Classpath::CompositeClasspath.new('2')
      end

      wrap_classpath :create_2

      def test_wrap_classpath
        cp = create_1
        assert_equal('1', cp.to_s)
        assert_equal(JavaClass::Classpath::CompositeClasspath, cp.class)

        cp = create_2
        assert_equal('2', cp.to_s)
        assert_equal(JavaClass::Dsl::LoadingClasspath, cp.class)
      end

    end

  end
end
