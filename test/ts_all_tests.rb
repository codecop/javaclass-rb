#! ruby
require 'test/unit/testsuite'
require 'test/unit' if $0 == __FILE__

require File.dirname(__FILE__) + '/test_string_ux'
require File.dirname(__FILE__) + '/test_string_hexdump'
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
require File.dirname(__FILE__) + '/test_any_classpath'
require File.dirname(__FILE__) + '/test_jar_searcher'
require File.dirname(__FILE__) + '/test_list'
require File.dirname(__FILE__) + '/test_class_entry'
require File.dirname(__FILE__) + '/test_package_entry'
require File.dirname(__FILE__) + '/test_java_name.rb'
require File.dirname(__FILE__) + '/test_java_name_factory.rb'
require File.dirname(__FILE__) + '/test_javaclass.rb'

class TsAllTests
  def self.suite
    suite = Test::Unit::TestSuite.new("Ruby Java Class")
    
    suite << TestString.suite
    suite << TestStringHexdump.suite
    
    # Java class parser
    suite << TestJavaClass::TestClassFile::TestClassVersion.suite
    suite << TestJavaClass::TestClassFile::TestConstants::TestBase.suite
    suite << TestJavaClass::TestClassFile::TestConstantPool.suite
    suite << TestJavaClass::TestClassFile::TestReferences.suite
    suite << TestJavaClass::TestClassFile::TestAccessFlags.suite
    suite << TestJavaClass::TestClassFile::TestJavaClassHeader.suite
    
    # classpath parser
    suite << TestJavaClass::TestClasspath::TestJarClasspath.suite
    suite << TestJavaClass::TestClasspath::TestFolderClasspath.suite
    suite << TestJavaClass::TestClasspath::TestJavaHomeClasspath.suite
    suite << TestJavaClass::TestClasspath::TestCompositeClasspath.suite
    suite << TestJavaClass::TestClasspath::TestAnyClasspath.suite
    
    # class list
    suite << TestJavaClass::TestClassList::TestJarSearcher.suite
    suite << TestJavaClass::TestClassList::TestList.suite
    suite << TestJavaClass::TestClassList::TestClassEntry.suite
    suite << TestJavaClass::TestClassList::TestPackageEntry.suite
    
    # general
    suite << TestJavaClass::TestJavaName.suite
    suite << TestJavaClass::TestJavaNameFactory.suite
    suite << TestJavaClass::TestJavaClassFacade.suite
    
    return suite
  end
  
end
