require File.dirname(__FILE__) + '/setup'
require 'javaclass/jar_class_list'

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

    def test_find_jars
      jars = @cs.find_jars("#{TEST_DATA_PATH}/jar_class_list")
      assert_equal(1, jars.size)
      assert_equal(JAR, jars[0])
    end

    def test_list_classes
      @cs.skip_inner_classes = false

      classes = @cs.list_classes(JAR)
      assert_equal(4, classes.size)
      assert_equal(INNER_CLASS, classes[0])
      assert_equal(PUBLIC_CLASS, classes[1])
      assert_equal(PUBLIC_INTERFACE, classes[2])
      assert_equal(PACKAGE_CLASS, classes[3])

      @cs.skip_inner_classes = true
      classes = @cs.list_classes(JAR)
      assert_equal(3, classes.size)
      assert_equal(PUBLIC_CLASS, classes[0])
      assert_equal(PUBLIC_INTERFACE, classes[1])
      assert_equal(PACKAGE_CLASS, classes[2])
    end

    def test_filter
      @cs.filters = ['packagename/']

      classes = @cs.list_classes(JAR)
      assert_equal(0, classes.size)
    end

    def test_if_public
      assert(!@cs.public?(JAR, PACKAGE_CLASS))
      assert(!@cs.public?(JAR, INNER_CLASS))
      assert(@cs.public?(JAR, PUBLIC_CLASS))
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

    def test_overall
      @cs.skip_package_classes = true

      list = @cs.compile_list(2, "#{TEST_DATA_PATH}/jar_class_list", MockList.new )

      assert_equal(2, list.size)
      assert_equal([PUBLIC_CLASS, PUBLIC_INTERFACE], list.entries)
      assert_equal([true, true], list.modifiers)
      assert_equal([2, 2], list.versions)
    end

  end

end