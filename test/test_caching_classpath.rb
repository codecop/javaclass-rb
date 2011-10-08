require File.dirname(__FILE__) + '/setup'
require 'javaclass/dsl/caching_classpath'
require File.dirname(__FILE__) + '/logging_folder_classpath'
require File.dirname(__FILE__) + '/test_folder_classpath'

module TestJavaClass
  module TestDsl

    class TestCachingClasspath < TestClasspath::TestFolderClasspath
      # extend TestFolderClasspath to execute all tests again

      def test_new_wrong_type
        assert_raise(ArgumentError){ 
          JavaClass::Dsl::CachingClasspath.new('3') 
        }
      end

      def setup
        super
        class << @cpe
          def load(*obj)
            load_binary(*obj)
          end
        end
        @cpe = JavaClass::Dsl::CachingClasspath.new(@cpe)
      end

      def test_load_cached
        @cpe.was_called = false
        @cpe.load('ClassVersionTest10')
        assert(@cpe.was_called)
        
        # load again, now it's still false
        @cpe.was_called = false
        @cpe.load('ClassVersionTest10')
        assert(!@cpe.was_called)
      end
    end

  end
end
