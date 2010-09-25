require File.dirname(__FILE__) + '/setup'
require 'javaclass/java_class_name'

class TestString < Test::Unit::TestCase
  def test_to_classname
    raise NotImplementedError, 'Need to write test_to_classname'
  end
end

module TestJavaClass
  class TestJavaClassName < Test::Unit::TestCase
    def setup
      @c0 = "Some.class".to_classname
      @cn = "at/kugel/tool/Some.class".to_classname
      @cm = "at/kugel/tool/SomeClassWithMoreNames.class".to_classname
    end
    
    def test_from_filename
      assert_equal("Some",@c0)
      assert_equal("at.kugel.tool.Some", @cn)
      assert_equal("at.kugel.tool.Some", "at.kugel.tool.Some".to_classname)
      
      assert_equal("at/kugel/tool/Some.java", @cn.to_java_filename)
      assert_equal("at/kugel/tool/Some.class", @cn.to_class_filename)
    end
    
    def test_package
      assert_equal("", @c0.package)
      assert_equal("at.kugel.tool", @cn.package)
    end
    
    def test_simple
      assert_equal("Some", @c0.simple_name)
      assert_equal("Some", @cn.simple_name)
    end
    
    def test_same_or_subpackage
      assert(@cn.same_or_subpackage?(%w[ at.kugel ]))
      assert(@cn.same_or_subpackage?(%w[ java at.kugel ]))
      
      assert(!@cn.same_or_subpackage?(%w[ at.kugel.tool.some ]))
      assert(!@c0.same_or_subpackage?(%w[ at.kugel ]))
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