require File.dirname(__FILE__) + '/setup'
require 'javaclass/jar_class_list'
require 'javaclass/classpath/jar_classpath'

module TestJavaClass
  class TestJarClassList < Test::Unit::TestCase

    JAR = File.expand_path("#{TEST_DATA_PATH}/jar_class_list/JarClassListTest.jar")

    PACKAGE_CLASS = "packagename/PackageClass.class"
    INNER_CLASS = "packagename/PublicClass$InnerClass.class"
    PUBLIC_CLASS = "packagename/PublicClass.class"
    PUBLIC_INTERFACE = "packagename/PublicInterface.class"
    def setup
      @cs = JavaClass::JarClassList.new
    end

    def test_skip_inner_classes_equals
      @cs.skip_inner_classes = false
      classes = @cs.filter_classes([INNER_CLASS, PUBLIC_CLASS, PUBLIC_INTERFACE, PACKAGE_CLASS])
      assert_equal(4, classes.size)
      assert_equal(INNER_CLASS, classes[0])
      assert_equal(PUBLIC_CLASS, classes[1])
      assert_equal(PUBLIC_INTERFACE, classes[2])
      assert_equal(PACKAGE_CLASS, classes[3])
    end

    def test_skip_inner_classes_equals
      @cs.skip_inner_classes = true
      classes = @cs.filter_classes([INNER_CLASS, PUBLIC_CLASS, PUBLIC_INTERFACE, PACKAGE_CLASS])
      assert_equal(3, classes.size)
      assert_equal(PUBLIC_CLASS, classes[0])
      assert_equal(PUBLIC_INTERFACE, classes[1])
      assert_equal(PACKAGE_CLASS, classes[2])
    end

    def test_skip_package_classes_equals
      @cs.skip_package_classes = true
      classes = @cs.filter_classes([INNER_CLASS, PUBLIC_CLASS, PUBLIC_INTERFACE, PACKAGE_CLASS])
      assert_equal(3, classes.size)
      assert_equal(PUBLIC_CLASS, classes[0])
      assert_equal(PUBLIC_INTERFACE, classes[1])
      assert_equal(INNER_CLASS, classes[2])
    end

    def test_filters_equals
      @cs.filters = ['packagename/']

      classes = @cs.filter_classes([INNER_CLASS, PUBLIC_CLASS, PUBLIC_INTERFACE, PACKAGE_CLASS])
      assert_equal(0, classes.size)
    end

    def test_public_eh
      @cpe = JavaClass::Classpath::JarClasspath.new(JAR)
      assert(!@cs.public?(@cpe, PACKAGE_CLASS))
      assert(!@cs.public?(@cpe, INNER_CLASS))
      assert(@cs.public?(@cpe, PUBLIC_CLASS))
    end

    class MockList # ZenTest SKIP
      attr_reader :versions
      attr_reader :modifiers
      attr_reader :entries
      def initialize
        @versions = []
        @modifiers = []
        @size = 0
        @entries = []
      end

      def add_class(entry, is_public, version)
        @entries << entry
        @modifiers << is_public
        @versions << version
      end

      def size
        @entries.size
      end
    end

    def test_compile_list
      @cs.skip_package_classes = true

      list = @cs.compile_list(2, "#{TEST_DATA_PATH}/jar_class_list", MockList.new )

      assert_equal(2, list.size)
      assert_equal([PUBLIC_CLASS, PUBLIC_INTERFACE], list.entries)
      assert_equal([true, true], list.modifiers)
      assert_equal([2, 2], list.versions)
    end

  end

end