require File.dirname(__FILE__) + '/setup'
require 'javaclass/classpath/any_classpath'

module TestJavaClass
  module TestClasspath
    
    class TestAnyClasspath < Test::Unit::TestCase
    
      def setup
        @cpe = JavaClass::Classpath::AnyClasspath.new(TEST_DATA_PATH)
      end

      def test_includes_eh
        # from folder
        assert(@cpe.includes?('access_flags.AccessFlagsTestAbstract'))
        # from jar, would have another package
        assert(@cpe.includes?('packagename/PublicClass'))
        # from jar, would have any package
        assert(@cpe.includes?('ClassVersionTest10'))
      end

    end

  end
end