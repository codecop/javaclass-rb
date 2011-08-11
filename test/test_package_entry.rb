require File.dirname(__FILE__) + '/setup'
require 'javaclass/classlist/package_entry'

module TestJavaClass
  module TestClassList

    class TestPackageEntry < Test::Unit::TestCase

      def test_size
        pkg = JavaClass::ClassList::PackageEntry.new('packagename', 2)
        assert_equal(0, pkg.size)
        pkg.add_class('packagename.PublicClass', true, 2);
        assert_equal(1, pkg.size)
        pkg.add_class('packagename.PublicInterface', true, 2);
        assert_equal(2, pkg.size)
      end

      def test_version
        pkg = JavaClass::ClassList::PackageEntry.new('packagename', 1)
        assert_equal([1], pkg.version)
        pkg.add_class('packagename.PublicClass', true, 2);
        assert_equal([1,2], pkg.version)
      end

      def test_add_class
        # fake methods for zentest, tested in all other tests
        assert(true)
      end

      def test_to_package_shortcut_s
        pkg = JavaClass::ClassList::PackageEntry.new('packagename', 2)
        pkg.add_class('packagename.PublicClass', true, 2);
        pkg.add_class('packagename.PublicInterface', true, 2);
        assert_equal([2], pkg.version)
        assert_equal(2, pkg.size)
        assert_equal("packagename [2] - \n" + "   PublicClass - \n" + "   PublicInterface - \n", pkg.to_package_shortcut_s(1,2))

        classes = pkg.classes
        assert_equal(2, classes.size)
        assert_equal('PublicClass', classes[0].name)
        assert_equal([2], classes[0].version)

        pkg.add_class('packagename.PublicClass', true, 3)
        pkg.add_class('packagename.SomeClass', true, 3)
        assert_equal([2,3], pkg.version)
        assert_equal(3, pkg.size)

        classes = pkg.classes
        assert_equal(3, classes.size)
        assert_equal([2,3], classes[0].version)
        assert_equal([2], classes[1].version)
        assert_equal([3], classes[2].version)
        assert_equal("packagename [2] - \n" + "   PublicClass - \n" + "   PublicInterface [-2] - \n"+ "   SomeClass [3] - \n", pkg.to_package_shortcut_s(1,3))
        assert_equal("packagename [2-3] - \n" + "   PublicClass - \n" + "   PublicInterface [-2] - \n"+ "   SomeClass [3] - \n", pkg.to_package_shortcut_s(1,4))
      end

      def test_to_package_shortcut_s_package
        pkg = JavaClass::ClassList::PackageEntry.new('packagename', 2)
        pkg.add_class('packagename.PublicClass', true, 2);
        pkg.add_class('packagename.PuckageClass', false, 2);
        assert_equal([2], pkg.version)
        assert_equal(2, pkg.size)
        assert_equal("packagename [2] - \n" + "   PublicClass - \n" + "   PuckageClass [2p] - \n", pkg.to_package_shortcut_s(1,2))
      end

      def test_spaceship
        sorted = [
          a=JavaClass::ClassList::PackageEntry.new('com.sun'),
          b=JavaClass::ClassList::PackageEntry.new('java.beans'),
          c=JavaClass::ClassList::PackageEntry.new('javax.ejb'),
          d=JavaClass::ClassList::PackageEntry.new('java.lang'),
          e=JavaClass::ClassList::PackageEntry.new('java.io')
        ].sort

        assert_equal(-1, d<=>a)
        assert_equal(-1, d<=>b)
        assert_equal(-1, d<=>c)
        assert_equal(-1, d<=>e)

        #sorting in packages is: java.lang, other java.*, javax, andere
        assert_equal('java.lang', sorted[0].name)
        assert_equal('java.beans', sorted[1].name)
        assert_equal('java.io', sorted[2].name)
        assert_equal('javax.ejb', sorted[3].name)
        assert_equal('com.sun', sorted[4].name)
      end

    end

  end
end
