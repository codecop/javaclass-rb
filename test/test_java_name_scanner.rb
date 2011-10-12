require File.dirname(__FILE__) + '/setup'
require 'javaclass/java_name_scanner'

module TestJavaClass
  
  class TestJavaNameScanner < Test::Unit::TestCase
    include JavaClass::JavaNameScanner
    
    def test_scan_text_for_class_names
      assert_equal([], scan_text_for_class_names(''))
      assert_equal(['java.lang.String'], scan_text_for_class_names('java.lang.String'))
      assert_equal(['java.lang.String'], scan_text_for_class_names("Bundle-Version: 1.0.0.qualifier\nBundle-Activator: java.lang.String\nBundle-ActivationPolicy: lazy"))
      assert_equal(['java.lang.String'], scan_text_for_class_names("   <extension\n      point=\"java.lang.String\">\n   </extension>"))
    end

    def test_scan_config_for_class_names
      result = scan_config_for_class_names("#{TEST_DATA_PATH}/java_name_scanner")
      assert_equal(2, result.size)
      assert_equal('some.PrivilegeCheck', result[0])
      assert_equal('some.plugin.Activator', result[1])
    end
  end

end