#! ruby
require 'test/unit/testsuite'
#require 'test/unit/ui/tk/testrunner'
#require 'test/unit/ui/console/testrunner'

require File.dirname(__FILE__) + '/tc_string_ux'
# require File.dirname(__FILE__) + '/tc_class_magic'
require File.dirname(__FILE__) + '/tc_class_version'
require File.dirname(__FILE__) + '/tc_constant_pool'
require File.dirname(__FILE__) + '/tc_java_class_header'

module TestJavaClass
  
  class TestSuite_AllTests
    def self.suite
      suite = Test::Unit::TestSuite.new("Ruby Java Class Parser")
      
      suite << TestString.suite
      suite << TestClassVersion.suite
      suite << TestConstantPool.suite
      suite << TestJavaClassHeader.suite
      
      return suite
    end
  end
  
end

#Test::Unit::UI::Tk::TestRunner.run(TestSuite_AllTests)
#Test::Unit::UI::Console::TestRunner.run(TestSuite_AllTests)
