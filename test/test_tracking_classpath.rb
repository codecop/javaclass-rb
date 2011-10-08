require File.dirname(__FILE__) + '/setup'
require 'javaclass/classpath/tracking_classpath'
require File.dirname(__FILE__) + '/test_folder_classpath'
require File.dirname(__FILE__) + '/test_composite_classpath'

module TestJavaClass
  module TestClasspath

    class TestTrackingFolderClasspath < TestFolderClasspath
      # extend TestFolderClasspath to execute all tests again

      def setup
        super
        @original = @cpe
        @cpe = JavaClass::Classpath::TrackingClasspath.new(@cpe)
      end

      def test_reset_access
        @cpe.mark_accessed('ClassVersionTest10')
        assert(@cpe.accessed?('ClassVersionTest10'))
        @cpe.reset_access
        assert(!@cpe.accessed?('ClassVersionTest10'))
      end

      def test_mark_accessed
        assert(!@cpe.accessed?)
        assert(!@cpe.accessed?('ClassVersionTest10'))
        @cpe.mark_accessed('ClassVersionTest10')
        assert(@cpe.accessed?('ClassVersionTest10'))
        assert(!@cpe.accessed?('ClassVersionTest11'))
        assert(@cpe.accessed?)
      end

      def test_load_binary_tracked
        assert(!@cpe.accessed?('ClassVersionTest10'))
        @cpe.load_binary('ClassVersionTest10')
        assert(@cpe.accessed?('ClassVersionTest10'))
      end

      def test_load_tracked
        class << @original
          def load(name)
            load_binary(name)
          end 
        end
        assert(!@cpe.accessed?('ClassVersionTest10'))
        @cpe.load('ClassVersionTest10')
        assert(@cpe.accessed?('ClassVersionTest10'))
      end
      
      def test_all_accessed
        @cpe.mark_accessed('ClassVersionTest11')
        @cpe.mark_accessed('ClassVersionTest10')
        assert_equal(['ClassVersionTest10.class', 'ClassVersionTest11.class'], @cpe.all_accessed)
      end

      def test_class_new_invalud
        assert_raise(RuntimeError){ 
          JavaClass::Classpath::TrackingClasspath.new('123')
        }
      end
      
    end

    class TestTrackingCompositeClasspath  < TestCompositeClasspath
      # extend TestCompositeClasspath to execute all tests again

      def test_reset_access
        @cpe.mark_accessed('package/ClassVersionTest11.class')
        assert(@cpe.accessed?('package/ClassVersionTest11.class'))
        @cpe.reset_access
        assert(!@cpe.accessed?('package/ClassVersionTest11.class'))
      end

      def test_mark_accessed
        assert(!@cpe.accessed?)
        assert(!@cpe.accessed?('ClassVersionTest10'))
        @cpe.mark_accessed('ClassVersionTest10')
        assert(@cpe.accessed?('ClassVersionTest10'))
        assert(!@cpe.accessed?('ClassVersionTest11'))
        assert(@cpe.accessed?)

        assert(!@cpe.elements[0].accessed?)
        assert(@cpe.elements[1].accessed?)
      end

      def test_load_binary_tracked
        assert(!@cpe.accessed?('ClassVersionTest10'))
        @cpe.load_binary('ClassVersionTest10')
        assert(@cpe.accessed?('ClassVersionTest10'))
      end

      def test_all_accessed
        @cpe.mark_accessed('ClassVersionTest11')
        @cpe.mark_accessed('ClassVersionTest10')
        assert_equal(['ClassVersionTest10.class', 'ClassVersionTest11.class'], @cpe.all_accessed)
      end

    end

  end
end
