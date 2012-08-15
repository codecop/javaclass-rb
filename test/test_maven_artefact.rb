require File.dirname(__FILE__) + '/setup'
require 'javaclass/classpath/maven_artefact'

module TestJavaClass
  module TestClasspath

    class TestMavenArtefact < Test::Unit::TestCase

      def test_make_title_given
        a = JavaClass::Classpath::MavenArtefact.new('commons-codec', 'commons-codec', '1.6', 'Some Title')
        assert_equal('Some Title', a.title)
      end

      def test_make_title_basic
        a = JavaClass::Classpath::MavenArtefact.new('commons-codec', 'commons-codec', '1.6')
        assert_equal('Commons Codec', a.title)
      end

      def test_make_title_number
        a = JavaClass::Classpath::MavenArtefact.new('org.apache.commons', 'commons-lang3', '3.1')
        assert_equal('Commons Lang', a.title)
      end

      def test_make_title_acronym
        a = JavaClass::Classpath::MavenArtefact.new('commons-cli', 'commons-cli', '1.2')
        assert_equal('Commons CLI', a.title)
      end

    end

  end
end