require File.dirname(__FILE__) + '/setup'
require 'javaclass/classlist/jar_searcher'
require 'javaclass/classpath/jar_classpath'

module TestJavaClass
  module TestClassList

    class TestJarSearcher < Test::Unit::TestCase

      PACKAGE_CLASS = "packagename/PackageClass.class"
      INNER_CLASS = "packagename/PublicClass$InnerClass.class"
      PUBLIC_CLASS = "packagename/PublicClass.class"
      PUBLIC_INTERFACE = "packagename/PublicInterface.class"
      CLASSES = [INNER_CLASS, PUBLIC_CLASS, PUBLIC_INTERFACE, PACKAGE_CLASS]

      def setup
        @cs = JavaClass::ClassList::JarSearcher.new
      end

      def test_filter_classes
        @cs.skip_inner_classes = false
        classes = @cs.filter_classes(CLASSES)
        assert_equal(4, classes.size)
        assert_equal(INNER_CLASS, classes[0])
        assert_equal(PUBLIC_CLASS, classes[1])
        assert_equal(PUBLIC_INTERFACE, classes[2])
        assert_equal(PACKAGE_CLASS, classes[3])
      end

      def test_skip_inner_classes_equals
        # @cs.skip_inner_classes = true # default
        classes = @cs.filter_classes(CLASSES)
        assert_equal(3, classes.size)
        assert_equal(PUBLIC_CLASS, classes[0])
        assert_equal(PUBLIC_INTERFACE, classes[1])
        assert_equal(PACKAGE_CLASS, classes[2])
      end

      def test_filters_equals
        @cs.filters = ['packagename/']
        classes = @cs.filter_classes(CLASSES)
        assert_equal(0, classes.size)
      end

      def test_public_eh
        @cpe = JavaClass::Classpath::JarClasspath.new(File.expand_path("#{TEST_DATA_PATH}/jar_searcher/JarClassListTest.jar"))
        assert(!@cs.public?(@cpe, PACKAGE_CLASS))
        assert(!@cs.public?(@cpe, INNER_CLASS))
        assert(@cs.public?(@cpe, PUBLIC_CLASS))
      end

      def test_public_eh_fails
        @cpe = JavaClass::Classpath::JarClasspath.new(File.expand_path("#{TEST_DATA_PATH}/jar_searcher/JarClassListTest.jar"))
        assert_raise(RuntimeError){ @cs.public?(@cpe, 'NonExistingClass') }
      end
      
      class MockList # ZenTest SKIP mock class
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
        list = @cs.compile_list(2, "#{TEST_DATA_PATH}/jar_searcher", MockList.new )

        assert_equal(3, list.size)
        assert_equal([PACKAGE_CLASS, PUBLIC_CLASS, PUBLIC_INTERFACE], list.entries)
        assert_equal([false, true, true], list.modifiers)
        assert_equal([2, 2, 2], list.versions)
      end

      def test_skip_package_classes_equals
        @cs.skip_package_classes = true
        list = @cs.compile_list(3, "#{TEST_DATA_PATH}/jar_searcher", MockList.new )

        assert_equal(2, list.size)
        assert_equal([PUBLIC_CLASS, PUBLIC_INTERFACE], list.entries)
      end

    end

  end
end