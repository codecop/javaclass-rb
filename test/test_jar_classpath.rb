require File.dirname(__FILE__) + '/setup'
require 'javaclass/classpath/jar_classpath'

module TestJavaClass
  module TestClasspath

    class TestJarClasspath < Test::Unit::TestCase

      def setup
        @folder = "#{TEST_DATA_PATH}/jar_classpath"
        @cpe = JavaClass::Classpath::JarClasspath.new("#{@folder}/JarClasspathTest.jar")
      end

      def test_count
        assert_equal(2, @cpe.count)
      end

      def test_additional_classpath
        assert_equal([], @cpe.additional_classpath)

        @cpe = JavaClass::Classpath::JarClasspath.new("#{@folder}/JarClasspathTestManifest.jar")
        assert_equal(["#{@folder}/JarClasspathTest.jar"], @cpe.additional_classpath)

        @cpe = JavaClass::Classpath::JarClasspath.new("#{@folder}/JarClasspathTestMultiManifest.jar")
        assert_equal(["#{@folder}/lib/httpunit-1.6.2.jar", "#{@folder}/lib/nekohtml-0.9.1.jar",
          "#{@folder}/lib/xercesImpl-2.5.jar", "#{@folder}/lib/js-1.5R4.1.jar"], @cpe.additional_classpath)
      end

      def test_jar_eh
        assert(@cpe.jar?)

        @cpe = JavaClass::Classpath::JarClasspath.new("#{@folder}/JarClasspathTest.zip")
        assert(!@cpe.jar?)
      end

      def test_includes_eh
        assert(@cpe.includes?('ClassVersionTest10.class'))
        assert(@cpe.includes?('ClassVersionTest10'))
        assert(!@cpe.includes?('ClassVersionTest11.class'))
        assert(!@cpe.includes?('ClassVersionTest11'))
      end

      def test_load_binary
        assert_equal(load_class('class_version/ClassVersionTest10'), @cpe.load_binary('ClassVersionTest10'))

        @cpe = JavaClass::Classpath::JarClasspath.new("#{@folder}/JarClasspathTest.zip")
        assert_equal(load_class('class_version/ClassVersionTest10'), @cpe.load_binary('ClassVersionTest10'))
      end

      def test_names
        assert_equal(['ClassVersionTest10.class', 'package/ClassVersionTest11.class'], @cpe.names)
      end

    end

  end
end