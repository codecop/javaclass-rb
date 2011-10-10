require File.dirname(__FILE__) + '/setup'
require 'javaclass/java_name'

class TestString < Test::Unit::TestCase

  def test_to_javaname
    assert_equal(JavaClass::JavaClassFileName, 'at/kugel/tool/Some.class'.to_javaname.class)
    assert_equal('Some', 'Some'.to_javaname)
    assert_equal('at/kugel/tool/Some.class', 'at/kugel/tool/Some.class'.to_javaname)
    #assert_equal("at\\kugel\\tool\\Some.java", "at\\kugel\\tool\\Some.java".to_javaname)
    assert_equal('at.kugel.tool.Some', 'at.kugel.tool.Some'.to_javaname)
  end

end

module TestJavaClass

  class TestPackageLogic < Test::Unit::TestCase
    include JavaClass::PackageLogic

    def setup
      @package = 'at.kugel.tool.'
    end
        
    def test_same_or_subpackage_of_eh
      assert(same_or_subpackage_of?(%w[ at.kugel ]))
      assert(same_or_subpackage_of?(%w[ at.kugel.tool ]))
      assert(!same_or_subpackage_of?(%w[ at.kugel.tool.some ]))
      assert(same_or_subpackage_of?(%w[ java at.kugel ]))

      @package = ''
      assert(!same_or_subpackage_of?(%w[ at at.kugel ]))
    end

    def test_subpackage_of_eh
      assert(subpackage_of?(%w[ at.kugel ]))
      assert(subpackage_of?(%w[ at.kugel.tool ]))
      assert(!subpackage_of?(%w[ at.kugel.tool.class ]))
    end

    def test_in_jdk_eh
      assert(!in_jdk?)

      @package = 'java.lang'
      assert(in_jdk?)
    end
        
  end
  
  class TestSimpleNameLogic < Test::Unit::TestCase
    include JavaClass::SimpleNameLogic

    def setup
      @simple_name = 'SomeClassWithMoreNames'
    end

    def test_split_simple_name
      assert_equal(['', 'SomeClassWithMoreNames'], split_simple_name(0))
      assert_equal(['Some', 'ClassWithMoreNames'], split_simple_name(1))
      assert_equal(['SomeClass', 'WithMoreNames'], split_simple_name(2))
      assert_equal(['SomeClassWith', 'MoreNames'], split_simple_name(3))
      assert_equal(['SomeClassWithMore', 'Names'], split_simple_name(4))
      assert_equal(['SomeClassWithMoreNames', ''], split_simple_name(5))
      assert_equal(['SomeClassWithMoreNames', ''], split_simple_name(6))

      assert_equal(['SomeClassWithMoreNames', ''], split_simple_name(-1))
      assert_equal(['SomeClassWithMore', 'Names'], split_simple_name(-2))
      assert_equal(['SomeClassWith', 'MoreNames'], split_simple_name(-3))
      assert_equal(['SomeClass', 'WithMoreNames'], split_simple_name(-4))
      assert_equal(['Some', 'ClassWithMoreNames'], split_simple_name(-5))
      assert_equal(['', 'SomeClassWithMoreNames'], split_simple_name(-6))
      assert_equal(['', 'SomeClassWithMoreNames'], split_simple_name(-7))
    end
  
  end
  
  class TestJavaQualifiedName < Test::Unit::TestCase

    def setup
      @simple_name = JavaClass::JavaQualifiedName.new('Some')
      @qualified_name= JavaClass::JavaQualifiedName.new('at.kugel.tool.Some')
    end

    def test_class_new_invalid
      assert_raise(ArgumentError) { JavaClass::JavaQualifiedName.new('at.kugel.tool/Some') }
      assert_raise(ArgumentError) { JavaClass::JavaQualifiedName.new('at.kugel.tool.') }
    end

    def test_class_new_caches
      cn = JavaClass::JavaQualifiedName.new('at.kugel.tool.Some', 1, 2 )
      assert_equal(1, cn.to_jvmname)
      assert_equal(2, cn.to_class_file)
    end
    
    def test_package
      assert_equal('', @simple_name.package)
      assert_equal('at.kugel.tool', @qualified_name.package)
    end

    def test_simple_name
      assert_equal('Some', @simple_name.simple_name)
      assert_equal('Some', @qualified_name.simple_name)
    end

    def test_full_name
      assert_equal('Some', @simple_name.full_name)
      assert_equal('at.kugel.tool.Some', @qualified_name.full_name)
    end

    def test_to_javaname
      assert_same(@qualified_name, @qualified_name.to_javaname)
    end

    def test_to_classname
      assert_same(@qualified_name, @qualified_name.to_classname)
    end

    def test_to_jvmname
      assert_equal('at/kugel/tool/Some', @qualified_name.to_jvmname)
      assert_same(@qualified_name.to_jvmname, @qualified_name.to_jvmname) # is saved
    end
  
    def test_to_java_file
      assert_equal('at/kugel/tool/Some.java', @qualified_name.to_java_file)
    end

    def test_to_class_file
      assert_equal('at/kugel/tool/Some.class', @qualified_name.to_class_file)
      assert_same(@qualified_name.to_class_file, @qualified_name.to_class_file) # is saved
    end
    
  end

  class TestJavaName < Test::Unit::TestCase

    def setup
      #@source_file = JavaClass::JavaName.new("at\\kugel\\tool\\Some.java")
      @jvm_path = JavaClass::JavaVMName.new('at/kugel/tool/SomeClassWithMoreNames')
      #@jvm_method_name = JavaClass::JavaName.new('at/kugel/tool/Some.<init>')
      @class_file = JavaClass::JavaClassFileName.new('at/kugel/tool/Some.class')
      @jdk_class_file = JavaClass::JavaClassFileName.new('java/lang/String.class')
      @jvm_array_name = JavaClass::JavaVMName.new('[Ljava/lang/String;')
    end

    def test_to_classname
      #assert_equal('at.kugel.tool.Some', @source_file.to_classname)
      assert_equal('at.kugel.tool.SomeClassWithMoreNames', @jvm_path.to_classname)
      #assert_equal('at.kugel.tool.Some', @jvm_method_name.to_classname)
      assert_equal('at.kugel.tool.Some', @class_file.to_classname)
      assert_equal('java.lang.String', @jdk_class_file.to_classname)
      assert_equal('java.lang.String', @jvm_array_name.to_classname)
    end

    def test_to_javaname
      assert(@class_file == @class_file.to_javaname)
      assert(@class_file === @class_file.to_javaname)
    end

    def test_to_jvmname
      #assert_equal('at/kugel/tool/Some', @source_file.to_jvmname)
      assert_equal('at/kugel/tool/SomeClassWithMoreNames', @jvm_path.to_jvmname)
      #assert_equal('at/kugel/tool/Some', @jvm_method_name.to_jvmname)
      assert_equal('at/kugel/tool/Some', @class_file.to_jvmname)
    end

    def test_to_java_file
      #assert_equal('at/kugel/tool/Some.java', @source_file.to_java_file)
      assert_equal('at/kugel/tool/SomeClassWithMoreNames.java', @jvm_path.to_java_file)
      #assert_equal('at/kugel/tool/Some.java', @jvm_method_name.to_java_file)
      assert_equal('at/kugel/tool/Some.java', @class_file.to_java_file)
    end

    def test_to_class_file
      #assert_equal('at/kugel/tool/Some.class', @source_file.to_class_file)
      assert_equal('at/kugel/tool/SomeClassWithMoreNames.class', @jvm_path.to_class_file)
      #assert_equal('at/kugel/tool/Some.class', @jvm_method_name.to_class_file)
      assert_equal('at/kugel/tool/Some.class', @class_file.to_class_file)
    end

    def test_full_name
      #assert_equal('at.kugel.tool.Some', @source_file.full_name)
      assert_equal('at.kugel.tool.SomeClassWithMoreNames', @jvm_path.full_name)
      #assert_equal('at.kugel.tool.Some', @jvm_method_name.full_name)
      assert_equal('at.kugel.tool.Some', @class_file.full_name)
    end

    def test_package
      #assert_equal('at.kugel.tool', @source_file.package)
      assert_equal('at.kugel.tool', @jvm_path.package)
    end

    def test_simple_name
      #assert_equal('Some', @source_file.simple_name)
      #assert_equal('SomeClassWithMoreNames', @jvm_path.simple_name)
    end

  end

end