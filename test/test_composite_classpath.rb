require File.dirname(__FILE__) + '/setup'
require 'javaclass'
# require 'javaclass/classpath/composite_classpath'

module TestJavaClass
  module TestClasspath
    
    class TestCompositeClasspath < Test::Unit::TestCase
      
      def setup
        @cpe = JavaClass::Classpath::CompositeClasspath.new
        @cpe.add_file_name "#{TEST_DATA_PATH}/JarClasspathTestManifest.jar"
      end
      
      def test_parse
        # TODO move this test somewhere else
        cp = JavaClass.classpath("#{TEST_DATA_PATH}/JavaHomeClasspathTest/jre-ext", 
                                 "#{TEST_DATA_PATH}/JarClasspathTestManifest.jar#{File::PATH_SEPARATOR}#{TEST_DATA_PATH}/JarClasspathTestFolder")
        elem = cp.elements
        assert_equal(5, elem.size)
        assert_equal("#{TEST_DATA_PATH}/JavaHomeClasspathTest/jre-ext/lib/rt.jar", elem[0].to_s)
        assert_equal("#{TEST_DATA_PATH}/JavaHomeClasspathTest/jre-ext/lib/ext/ext.jar", elem[1].to_s)
        assert_equal("#{TEST_DATA_PATH}/JarClasspathTestManifest.jar", elem[2].to_s)
        assert_equal("#{TEST_DATA_PATH}/JarClasspathTest.jar", elem[3].to_s)
        assert_equal("#{TEST_DATA_PATH}/JarClasspathTestFolder", elem[4].to_s)
      end
      
      def test_add_element
        raise NotImplementedError, 'Need to write test_add_element'
      end
      
      def test_add_file_name
        assert(true) # tested in setup
      end
      
      def test_additional_classpath
        # dummy
        assert_equal([], @cpe.additional_classpath)
      end
      
      def test_jar_eh
        # dummy
        assert(!@cpe.jar?)
      end
      
      def test_count
        assert_equal(2+1, @cpe.count)
      end
      
      def test_elements
        raise NotImplementedError, 'Need to write test_elements'
      end
      
      def test_includes_eh
        assert(@cpe.includes?('ClassVersionTest11.class'))
        assert(@cpe.includes?('ClassVersionTest11'))
        assert(@cpe.includes?('ClassVersionTest10.class'))
        assert(@cpe.includes?('ClassVersionTest10'))
      end
      
      def test_load_binary
        assert_equal(load_class('ClassVersionTest11'), @cpe.load_binary('ClassVersionTest11'))
        assert_equal(load_class('ClassVersionTest10'), @cpe.load_binary('ClassVersionTest10'))
        assert_equal(load_class('ClassVersionTest11'), @cpe.load_binary('package/ClassVersionTest11.class'))
      end
      
      def test_names
        assert_equal(['ClassVersionTest11.class', 'ClassVersionTest10.class', 'package/ClassVersionTest11.class'], @cpe.names)
      end
      
    end
    
  end
end