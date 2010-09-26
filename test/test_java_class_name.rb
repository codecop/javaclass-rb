require File.dirname(__FILE__) + '/setup'
require 'javaclass/java_class_name'

class TestString < Test::Unit::TestCase
  
  def test_to_classname
    assert_equal('Some', 'Some.class'.to_javaname.to_classname)
    assert_equal('at.kugel.tool.Some', 'at/kugel/tool/Some.class'.to_javaname.to_classname)
    assert_equal('at.kugel.tool.Some', "at\\kugel\\tool\\Some.java".to_javaname.to_classname)
    assert_equal('at.kugel.tool.Some', 'at.kugel.tool.Some'.to_javaname.to_classname)
  end
  
end

module TestJavaClass
  class TestJavaClassName < Test::Unit::TestCase
    
    def setup
      @c0 = JavaClass::JavaClassName.new('dummy', 'Some')
      @cn = JavaClass::JavaClassName.new('dummy', 'at.kugel.tool.Some')
      @cm = JavaClass::JavaClassName.new('dummy', 'at.kugel.tool.SomeClassWithMoreNames') 
    end

    def test_to_classname
      assert_equal('Some', @c0.to_classname)
      assert_equal('at.kugel.tool.Some', @cn.to_classname)
    end
    
    def test_to_javaname
      assert(@cn == @cn.to_javaname)
      assert(@cn === @cn.to_javaname)
    end
    
    def test_to_jvmname
      assert_equal('at/kugel/tool/Some', @cn.to_jvmname)
    end
    
    def test_to_java_filename
      assert_equal('at/kugel/tool/Some.java', @cn.to_java_filename)
    end
    
    def test_to_class_filename
      assert_equal('at/kugel/tool/Some.class', @cn.to_class_filename)
    end
    
    def test_package
      assert_equal('', @c0.package)
      assert_equal('at.kugel.tool', @cn.package)
    end
    
    def test_simple_name
      assert_equal('Some', @c0.simple_name)
      assert_equal('Some', @cn.simple_name)
    end
    
    def test_same_or_subpackage_of_eh
      assert(@cn.same_or_subpackage_of?(%w[ at.kugel ]))
      assert(@cn.same_or_subpackage_of?(%w[ at.kugel.tool ]))
      assert(!@cn.same_or_subpackage_of?(%w[ at.kugel.tool.some ]))
      assert(@cn.same_or_subpackage_of?(%w[ java at.kugel ]))
      
      assert(!@c0.same_or_subpackage_of?(%w[ at at.kugel ]))
    end
    
    def test_subpackage_of_eh
      assert(@cn.subpackage_of?(%w[ at.kugel ]))
      assert(!@cn.subpackage_of?(%w[ at.kugel.tool ]))
      assert(!@cn.subpackage_of?(%w[ at.kugel.tool.some ]))
    end
    
    def test_split_simple_name
      assert_equal(['', 'SomeClassWithMoreNames'], @cm.split_simple_name(0))
      assert_equal(['Some', 'ClassWithMoreNames'], @cm.split_simple_name(1))
      assert_equal(['SomeClass', 'WithMoreNames'], @cm.split_simple_name(2))
      assert_equal(['SomeClassWith', 'MoreNames'], @cm.split_simple_name(3))
      assert_equal(['SomeClassWithMore', 'Names'], @cm.split_simple_name(4))
      assert_equal(['SomeClassWithMoreNames', ''], @cm.split_simple_name(5))
      assert_equal(['SomeClassWithMoreNames', ''], @cm.split_simple_name(6))
      
      assert_equal(['SomeClassWithMoreNames', ''], @cm.split_simple_name(-1))
      assert_equal(['SomeClassWithMore', 'Names'], @cm.split_simple_name(-2))
      assert_equal(['SomeClassWith', 'MoreNames'], @cm.split_simple_name(-3))
      assert_equal(['SomeClass', 'WithMoreNames'], @cm.split_simple_name(-4))
      assert_equal(['Some', 'ClassWithMoreNames'], @cm.split_simple_name(-5))
      assert_equal(['', 'SomeClassWithMoreNames'], @cm.split_simple_name(-6))
      assert_equal(['', 'SomeClassWithMoreNames'], @cm.split_simple_name(-7))
    end
    
  end
  
end