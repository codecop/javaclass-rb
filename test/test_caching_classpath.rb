require File.dirname(__FILE__) + '/setup'
require 'javaclass/classpath/caching_classpath'
require File.dirname(__FILE__) + '/logging_folder_classpath'
require File.dirname(__FILE__) + '/test_folder_classpath'

module TestJavaClass
  module TestClasspath

    class TestCachingClasspath < TestFolderClasspath
      # extend TestFolderClasspath to execute all tests again

      def test_new_wrong_type
        assert_raise(RuntimeError){ 
          JavaClass::Classpath::CachingClasspath.new('3') 
        }
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
