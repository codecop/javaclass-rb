require File.dirname(__FILE__) + '/logging_folder_classpath'
require File.dirname(__FILE__) + '/test_folder_classpath'
require 'javaclass/classpath/caching_classpath'

module TestJavaClass
  module TestClasspath

    class TestCachingClasspath < TestFolderClasspath
      # extend TestFolderClasspath to execute all tests again

      def test_delegating
        d = JavaClass::Classpath::CachingClasspath.new(String.new('3'))
        assert_equal(3, d.to_i)
        assert_equal('33', d * 2)
        assert_equal('a', d.sub(/./, 'a'))
      end

      def setup
        super
        @cpe = JavaClass::Classpath::CachingClasspath.new(@cpe)
      end

      def test_load_binary_cached
        @cpe.was_called = false
        @cpe.load_binary('ClassVersionTest10')
        assert(@cpe.was_called)
        
        # load again, now it's still false
        @cpe.was_called = false
        @cpe.load_binary('ClassVersionTest10')
        assert(!@cpe.was_called)
      end
    end

  end
end
