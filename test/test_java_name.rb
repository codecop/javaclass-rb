require File.dirname(__FILE__) + '/setup'
require 'javaclass/java_name'

class TestString < Test::Unit::TestCase

  def test_to_javaname
    assert_equal(JavaClass::JavaName, 'at/kugel/tool/Some.class'.to_javaname.class)
    assert_equal('Some', 'Some'.to_javaname)
    assert_equal('at/kugel/tool/Some.class', 'at/kugel/tool/Some.class'.to_javaname)
    assert_equal("at\\kugel\\tool\\Some.java", "at\\kugel\\tool\\Some.java".to_javaname)
    assert_equal('at.kugel.tool.Some', 'at.kugel.tool.Some'.to_javaname)
  end

end

module TestJavaClass

  class TestJavaName < Test::Unit::TestCase

    def setup
      @c0 = JavaClass::JavaName.new('Some')
      @cn = JavaClass::JavaName.new("at\\kugel\\tool\\Some.java")
      @cm = JavaClass::JavaName.new('at/kugel/tool/SomeClassWithMoreNames')
      @cs = JavaClass::JavaName.new('at/kugel/tool/Some.<init>')
      @cc = JavaClass::JavaName.new('at/kugel/tool/Some.class')
      @cj = JavaClass::JavaName.new('java/lang/String.class')
    end

    def test_to_classname
      assert_equal('Some', @c0.to_classname)
      assert_equal('at.kugel.tool.Some', @cn.to_classname)
      assert_equal('at.kugel.tool.SomeClassWithMoreNames', @cm.to_classname)
      assert_equal('at.kugel.tool.Some', @cs.to_classname)
      assert_equal('at.kugel.tool.Some', @cc.to_classname)
    end

    def test_to_javaname
      assert(@cn == @cn.to_javaname)
      assert(@cn === @cn.to_javaname)
    end

    def test_to_jvmname
      assert_equal('Some', @c0.to_jvmname)
      assert_equal('at/kugel/tool/Some', @cn.to_jvmname)
      assert_equal('at/kugel/tool/SomeClassWithMoreNames', @cm.to_jvmname)
    end

    def test_to_java_file
      assert_equal('Some.java', @c0.to_java_file)
      assert_equal('at/kugel/tool/Some.java', @cn.to_java_file)
      assert_equal('at/kugel/tool/SomeClassWithMoreNames.java', @cm.to_java_file)
    end

    def test_to_class_file
      assert_equal('Some.class', @c0.to_class_file)
      assert_equal('at/kugel/tool/Some.class', @cn.to_class_file)
      assert_equal('at/kugel/tool/SomeClassWithMoreNames.class', @cm.to_class_file)
      assert_equal('at/kugel/tool/Some.class', @cc.to_class_file)
    end

    def test_full_name
      assert_equal('Some', @c0.full_name)
      assert_equal('at.kugel.tool.Some', @cn.full_name)
      assert_equal('at.kugel.tool.SomeClassWithMoreNames', @cm.full_name)
      assert_equal('at.kugel.tool.Some', @cc.full_name)
    end

    def test_package
      assert_equal('', @c0.package)
      assert_equal('at.kugel.tool', @cn.package)
      assert_equal('at.kugel.tool', @cm.package)
    end

    def test_simple_name
      assert_equal('Some', @c0.simple_name)
      assert_equal('Some', @cn.simple_name)
      assert_equal('SomeClassWithMoreNames', @cm.simple_name)

      # simple name is a classname itself
      assert_equal('Some.class', @cn.simple_name.to_class_file)
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

    def test_in_jdk_eh
      assert(!@cn.in_jdk?)
      assert(@cj.in_jdk?)
    end
  end

end