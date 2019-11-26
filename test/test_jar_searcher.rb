require File.dirname(__FILE__) + '/setup'
require 'javaclass/classlist/jar_searcher'
require 'javaclass/classpath/folder_classpath'
require 'javaclass/classpath/jar_classpath'

module TestJavaClass
  module TestClassList

    class TestJarSearcher < Test::Unit::TestCase

      PACKAGE_CLASS = "packagename/PackageClass.class"
      INNER_CLASS = "packagename/PublicClass$PublicClass_PackageInnerClass.class"
      PUBLIC_INNER_CLASS = "packagename/PackageClass$PackageClass_PublicInnerClass.class"
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
        @cpe = create_jar_searcher
        assert(!@cs.public?(@cpe, PACKAGE_CLASS))
        assert(!@cs.public?(@cpe, INNER_CLASS))
        assert(@cs.public?(@cpe, PUBLIC_CLASS))
        assert(@cs.public?(@cpe, PUBLIC_INNER_CLASS))
      end
      
      def test_public_eh_fails
        @cpe = create_jar_searcher
        assert_raise(JavaClass::Classpath::ClassNotFoundError){ @cs.public?(@cpe, 'NonExistingClass') }

        @cpe = JavaClass::Classpath::FolderClasspath.new(File.expand_path("#{TEST_DATA_PATH}/jar_searcher"))
        assert_raise(JavaClass::ClassFile::ClassFormatError) { 
          @cs.public?(@cpe, 'BrokenRunnable_102') 
        }
      end

      def create_jar_searcher
        JavaClass::Classpath::JarClasspath.new(File.expand_path("#{TEST_DATA_PATH}/jar_searcher/JarClassListTest.jar"))
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
        
        def to_s
          @entries.join("\n")
        end
      end

      def test_compile_list_no_inner_classes
        # @cs.skip_inner_classes = true # default
        # @cs.skip_package_classes = false # default

        list = @cs.compile_list(2, "#{TEST_DATA_PATH}/jar_searcher", MockList.new )

        assert_equal(3, list.size)
        assert_equal([PACKAGE_CLASS, PUBLIC_CLASS, PUBLIC_INTERFACE], list.entries)
        assert_equal([false, true, true], list.modifiers)
        assert_equal([2, 2, 2], list.versions)
      end

      def test_compile_list_no_inner_no_package_classes
        # @cs.skip_inner_classes = true # default
        @cs.skip_package_classes = true
        
        list = @cs.compile_list(3, "#{TEST_DATA_PATH}/jar_searcher", MockList.new )

        assert_equal(2, list.size)
        assert_equal([PUBLIC_CLASS, PUBLIC_INTERFACE], list.entries)
      end

      def test_compile_list_all_public_and_package_classes
        @cs.skip_inner_classes = false
        # @cs.skip_package_classes = false # default
        
        list = @cs.compile_list(3, "#{TEST_DATA_PATH}/jar_searcher", MockList.new )
        
        assert_equal(3 + 2 + 2, list.size) # 3 files, 2 static inner in public, 2 static inner in package 
      end
      
        # @cs.skip_inner_classes = false 
        # @cs.skip_package_classes = true


      
    end

  end
end