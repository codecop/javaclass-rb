require File.dirname(__FILE__) + '/setup'
require 'javaclass/classpath/jar_classpath'

class TestJarClasspath < Test::Unit::TestCase
  
  def test_count
    cpe = JavaClass::Classpath::JarClasspath.new("#{TEST_DATA_PATH}/JarClasspathTest.jar")
    assert_equal(1, cpe.count)
  end
  
  def test_additional_classpath
    cpe = JavaClass::Classpath::JarClasspath.new("#{TEST_DATA_PATH}/JarClasspathTest.jar")
    assert_equal([], cpe.additional_classpath)

    cpe = JavaClass::Classpath::JarClasspath.new("#{TEST_DATA_PATH}/JarClasspathTestManifest.jar")
    assert_equal(['JarClasspathTest.jar'], cpe.additional_classpath)
    
    # TODO add test for multi line manifest
#Version: 1.0.0
#Main-Class: at.kugel.tool.disconnect.Main
#Class-Path: lib/httpunit-1.6.2.jar lib/nekohtml-0.9.1.jar             
#   lib/xercesImpl-2.5.jar lib/js-1.5R4.1.jar
    
  end
  
  def test_jar
    cpe = JavaClass::Classpath::JarClasspath.new("#{TEST_DATA_PATH}/JarClasspathTest.jar")
    assert(cpe.jar?)
    
    cpe = JavaClass::Classpath::JarClasspath.new("#{TEST_DATA_PATH}/JarClasspathTest.zip")
    assert(!cpe.jar?)
  end
  
  def test_includes
    cpe = JavaClass::Classpath::JarClasspath.new("#{TEST_DATA_PATH}/JarClasspathTest.jar")
    assert(cpe.includes?('ClassVersionTest10.class'))
    assert(cpe.includes?('ClassVersionTest10'))
  end
  
  def test_load_binary
    cpe = JavaClass::Classpath::JarClasspath.new("#{TEST_DATA_PATH}/JarClasspathTest.jar")
    assert_equal(load_class('ClassVersionTest10'), cpe.load_binary('ClassVersionTest10'))
    
    cpe = JavaClass::Classpath::JarClasspath.new("#{TEST_DATA_PATH}/JarClasspathTest.zip")
    assert_equal(load_class('ClassVersionTest10'), cpe.load_binary('ClassVersionTest10'))
  end
  
end
