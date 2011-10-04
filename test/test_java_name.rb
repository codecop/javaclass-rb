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
      @simple_name = JavaClass::JavaName.new('Some')
      @source_file = JavaClass::JavaName.new("at\\kugel\\tool\\Some.java")
      @jvm_path = JavaClass::JavaName.new('at/kugel/tool/SomeClassWithMoreNames')
      @jvm_method_name = JavaClass::JavaName.new('at/kugel/tool/Some.<init>')
      @class_file = JavaClass::JavaName.new('at/kugel/tool/Some.class')
      @jdk_class_file = JavaClass::JavaName.new('java/lang/String.class')
      @mixed_class_file = JavaClass::JavaName.new('folder.version/some/String.class')
      @jvm_array_name = JavaClass::JavaName.new('[Ljava.lang.String;')
    end

    def test_to_classname
      assert_equal('Some', @simple_name.to_classname)
      assert_equal('at.kugel.tool.Some', @source_file.to_classname)
      assert_equal('at.kugel.tool.SomeClassWithMoreNames', @jvm_path.to_classname)
      assert_equal('at.kugel.tool.Some', @jvm_method_name.to_classname)
      assert_equal('at.kugel.tool.Some', @class_file.to_classname)
      assert_equal('folder.version/some/String', @mixed_class_file.to_classname)
      assert_equal('java.lang.String', @jvm_array_name.to_classname)
    end

    def test_to_javaname
      assert(@source_file == @source_file.to_javaname)
      assert(@source_file === @source_file.to_javaname)
    end

    def test_to_jvmname
      assert_equal('Some', @simple_name.to_jvmname)
      assert_equal('at/kugel/tool/Some', @source_file.to_jvmname)
      assert_equal('at/kugel/tool/SomeClassWithMoreNames', @jvm_path.to_jvmname)
      assert_equal('at/kugel/tool/Some', @jvm_method_name.to_jvmname)
      assert_equal('at/kugel/tool/Some', @class_file.to_jvmname)
      assert_equal('folder.version/some/String', @mixed_class_file.to_jvmname)
    end

    def test_to_java_file
      assert_equal('Some.java', @simple_name.to_java_file)
      assert_equal('at/kugel/tool/Some.java', @source_file.to_java_file)
      assert_equal('at/kugel/tool/SomeClassWithMoreNames.java', @jvm_path.to_java_file)
      assert_equal('at/kugel/tool/Some.java', @jvm_method_name.to_java_file)
      assert_equal('at/kugel/tool/Some.java', @class_file.to_java_file)
      assert_equal('folder.version/some/String.java', @mixed_class_file.to_java_file)
    end

    def test_to_class_file
      assert_equal('Some.class', @simple_name.to_class_file)
      assert_equal('at/kugel/tool/Some.class', @source_file.to_class_file)
      assert_equal('at/kugel/tool/SomeClassWithMoreNames.class', @jvm_path.to_class_file)
      assert_equal('at/kugel/tool/Some.class', @jvm_method_name.to_class_file)
      assert_equal('at/kugel/tool/Some.class', @class_file.to_class_file)
      assert_equal('folder.version/some/String.class', @mixed_class_file.to_class_file)
    end

    def test_full_name
      assert_equal('Some', @simple_name.full_name)
      assert_equal('at.kugel.tool.Some', @source_file.full_name)
      assert_equal('at.kugel.tool.SomeClassWithMoreNames', @jvm_path.full_name)
      assert_equal('at.kugel.tool.Some', @jvm_method_name.full_name)
      assert_equal('at.kugel.tool.Some', @class_file.full_name)
      assert_equal('folder.version/some/String', @mixed_class_file.full_name)
    end

    def test_package
      assert_equal('', @simple_name.package)
      assert_equal('at.kugel.tool', @source_file.package)
      assert_equal('at.kugel.tool', @jvm_path.package)
    end

    def test_simple_name
      assert_equal('Some', @simple_name.simple_name)
      assert_equal('Some', @source_file.simple_name)
      assert_equal('SomeClassWithMoreNames', @jvm_path.simple_name)
      assert_equal('String', @mixed_class_file.simple_name)
    end

    def test_same_or_subpackage_of_eh
      assert(@source_file.same_or_subpackage_of?(%w[ at.kugel ]))
      assert(@source_file.same_or_subpackage_of?(%w[ at.kugel.tool ]))
      assert(!@source_file.same_or_subpackage_of?(%w[ at.kugel.tool.some ]))
      assert(@source_file.same_or_subpackage_of?(%w[ java at.kugel ]))

      assert(!@simple_name.same_or_subpackage_of?(%w[ at at.kugel ]))
    end

    def test_subpackage_of_eh
      assert(@source_file.subpackage_of?(%w[ at.kugel ]))
      assert(!@source_file.subpackage_of?(%w[ at.kugel.tool ]))
      assert(!@source_file.subpackage_of?(%w[ at.kugel.tool.some ]))
    end

    def test_split_simple_name
      assert_equal(['', 'SomeClassWithMoreNames'], @jvm_path.split_simple_name(0))
      assert_equal(['Some', 'ClassWithMoreNames'], @jvm_path.split_simple_name(1))
      assert_equal(['SomeClass', 'WithMoreNames'], @jvm_path.split_simple_name(2))
      assert_equal(['SomeClassWith', 'MoreNames'], @jvm_path.split_simple_name(3))
      assert_equal(['SomeClassWithMore', 'Names'], @jvm_path.split_simple_name(4))
      assert_equal(['SomeClassWithMoreNames', ''], @jvm_path.split_simple_name(5))
      assert_equal(['SomeClassWithMoreNames', ''], @jvm_path.split_simple_name(6))

      assert_equal(['SomeClassWithMoreNames', ''], @jvm_path.split_simple_name(-1))
      assert_equal(['SomeClassWithMore', 'Names'], @jvm_path.split_simple_name(-2))
      assert_equal(['SomeClassWith', 'MoreNames'], @jvm_path.split_simple_name(-3))
      assert_equal(['SomeClass', 'WithMoreNames'], @jvm_path.split_simple_name(-4))
      assert_equal(['Some', 'ClassWithMoreNames'], @jvm_path.split_simple_name(-5))
      assert_equal(['', 'SomeClassWithMoreNames'], @jvm_path.split_simple_name(-6))
      assert_equal(['', 'SomeClassWithMoreNames'], @jvm_path.split_simple_name(-7))
    end

    def test_in_jdk_eh
      assert(!@source_file.in_jdk?)
      assert(@jdk_class_file.in_jdk?)
    end
  end

end