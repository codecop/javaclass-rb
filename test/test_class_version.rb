require File.dirname(__FILE__) + '/setup'
require 'javaclass/classfile/class_version'

module TestJavaClass
  module TestClassFile

    class TestClassVersion < Test::Unit::TestCase

      def setup
        @v = (0..7).collect do |i|
          JavaClass::ClassFile::ClassVersion.new(load_class("class_version/ClassVersionTest1#{i}"))
        end
      end

      # Assert the list of +@v+ against the list of _expectations_ when invoking the given block.
      def assert_classes(expectations)
        (0...expectations.size).each do |i|
          assert_equal(expectations[i], yield(@v[i]), "#{i}. element is wrong")
        end
      end

      def test_major
        assert_classes([45, 45, 46, 47, 48, 49, 50, 51]) { |v| v.major }
      end

      def test_minor
        assert_classes([3, 3, 0, 0, 0, 0, 0, 0]) {|v| v.minor}
        assert_equal(3, @v[1].minor) # shouldn't it be > 45.3, so JDK 1.1 still generates 1.0 byte code
      end

      def test_to_s
        assert_equal('50.0', @v[6].to_s)
        assert_equal('45.3', @v[0].to_s)
      end

      def test_dump
        assert_equal(['  minor version: 0', '  major version: 50'], @v[6].dump)
      end

      def test_to_f
        assert_equal(50.0, @v[6].to_f)
        assert_equal(45.3, @v[0].to_f)

        v = JavaClass::ClassFile::ClassVersion.new("....\000\xff\0002")
        assert_equal(50.255, v.to_f)

        v = JavaClass::ClassFile::ClassVersion.new("....\xff\xff\0002")
        assert_equal(50.65535, v.to_f)
      end

      def test_jdk_version
        assert_classes(%w[1.0 1.0 1.2 1.3 1.4 1.5 1.6 1.7]) { |v| v.jdk_version }

        v = JavaClass::ClassFile::ClassVersion.new("....\000\xff\0002")
        assert_equal('unknown', v.jdk_version)
      end

    end

  end
end