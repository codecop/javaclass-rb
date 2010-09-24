require File.dirname(__FILE__) + '/setup'
require 'javaclass/classpath/java_home_classpath'

module TestJavaClass
  module TestClasspath
    
    class TestJavaHomeClasspath < Test::Unit::TestCase
      
      def setup
        @folder = "#{TEST_DATA_PATH}/java_home_classpath"
        @cpe = JavaClass::Classpath::JavaHomeClasspath.new("#{@folder}/jre")
      end
      
      def test_count
        assert_equal(1, @cpe.count)

        @cpe = JavaClass::Classpath::JavaHomeClasspath.new("#{@folder}/jdk")
        assert_equal(1, @cpe.count)
      end
      
      def test_additional_classpath
        assert_equal([], @cpe.additional_classpath)
        
        @cpe = JavaClass::Classpath::JavaHomeClasspath.new("#{@folder}/jre-ext")
        assert_equal(["#{@folder}/jre-ext/lib/ext/ext.jar"], @cpe.additional_classpath)
      end
      
      def test_jar_eh
        assert(@cpe.jar?)
      end
      
      def test_includes_eh
        assert(@cpe.includes?('ClassVersionTest10.class'))
        assert(@cpe.includes?('ClassVersionTest10'))
        assert(!@cpe.includes?('ClassVersionTest11.class'))
        assert(!@cpe.includes?('ClassVersionTest11'))
      end
      
      def test_load_binary
        assert_equal(load_class('class_version/ClassVersionTest10'), @cpe.load_binary('ClassVersionTest10'))
      end
      
      def test_names
        assert_equal(['ClassVersionTest10.class'], @cpe.names)
      end
      
    end
    
  end
end
