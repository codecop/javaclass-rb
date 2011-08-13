require File.dirname(__FILE__) + '/logging_folder_classpath'
require 'javaclass/classpath/caching_classpath'

module TestJavaClass
  module TestClasspath

    class TestCachingClasspath < Test::Unit::TestCase

      def test_string
        d = JavaClass::Classpath::CachingClasspath.new(String.new('3'))
        assert_equal(3, d.to_i)
        assert_equal('33', d * 2)
        assert_equal('a', d.sub(/./, 'a'))
      end

      # TODO create cache with folder
      # load once, was_called is true, reset it
      # load again, now it's still false
      
      # TODO else execute all tests that folderclasspath is supposed to 
    end

  end
end