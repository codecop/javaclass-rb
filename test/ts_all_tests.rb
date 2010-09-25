#! ruby
require 'test/unit/testsuite'
require 'test/unit' if $0 == __FILE__

require File.dirname(__FILE__) + '/test_string_ux'
# require File.dirname(__FILE__) + '/test_class_magic'
require File.dirname(__FILE__) + '/test_class_version'
require File.dirname(__FILE__) + '/test_base'
require File.dirname(__FILE__) + '/test_constant_pool'
require File.dirname(__FILE__) + '/test_references'
require File.dirname(__FILE__) + '/test_access_flags'
require File.dirname(__FILE__) + '/test_java_class_header'

require File.dirname(__FILE__) + '/test_jar_classpath'
require File.dirname(__FILE__) + '/test_folder_classpath'
require File.dirname(__FILE__) + '/test_java_home_classpath'
require File.dirname(__FILE__) + '/test_composite_classpath'

require File.dirname(__FILE__) + '/test_java_class_name.rb'

module TestJavaClass
  
  class TestSuite_AllTests
    def self.suite
      suite = Test::Unit::TestSuite.new("Ruby Java Class")
      
      # Java class parser
      suite << TestString.suite
      suite << TestClassFile::TestClassVersion.suite
      suite << TestClassFile::TestConstants::TestBase.suite
      suite << TestClassFile::TestConstantPool.suite
      suite << TestClassFile::TestReferences.suite
      suite << TestClassFile::TestAccessFlags.suite
      suite << TestClassFile::TestJavaClassHeader.suite
      
      # classpath parser
      suite << TestClasspath::TestJarClasspath.suite
      suite << TestClasspath::TestFolderClasspath.suite
      suite << TestClasspath::TestJavaHomeClasspath.suite
      suite << TestClasspath::TestCompositeClasspath.suite
      
      suite << TestJavaClassName.suite
      
      return suite
    end
  end
  
end
