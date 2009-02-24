#! ruby
require 'test/unit/testsuite'
#require 'test/unit/ui/tk/testrunner'
#require 'test/unit/ui/console/testrunner'

require File.dirname(__FILE__) + '/tc_string'
require File.dirname(__FILE__) + '/tc_java_class_header'

class TestSuite_AllTests
  def self.suite
    suite = Test::Unit::TestSuite.new("Ruby Java Class Parser")
    
    suite << TestString.suite
    suite << TestJavaClassHeader.suite
    
    return suite
  end
end

#Test::Unit::UI::Tk::TestRunner.run(TestSuite_AllTests)
#Test::Unit::UI::Console::TestRunner.run(TestSuite_AllTests)
