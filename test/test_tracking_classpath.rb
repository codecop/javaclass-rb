require File.dirname(__FILE__) + '/setup'
require 'javaclass/classpath/tracking_classpath'
require File.dirname(__FILE__) + '/test_folder_classpath'

module TestJavaClass
  module TestClasspath

    class TestTrackingClasspath < TestFolderClasspath
      # extend TestFolderClasspath to execute all tests again

      def setup
        super
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
      
      def test_all_accessed
        @cpe.mark_accessed('ClassVersionTest11')
        @cpe.mark_accessed('ClassVersionTest10')
        assert_equal(['ClassVersionTest10', 'ClassVersionTest11'], @cpe.all_accessed)
      end
      
    end

  end
end
