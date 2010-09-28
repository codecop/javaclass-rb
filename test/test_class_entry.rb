require File.dirname(__FILE__) + '/setup'
require 'javaclass/classlist/class_entry'

module TestJavaClass
  module TestClassList
    
    class TestClassEntry < Test::Unit::TestCase
      
      attr_reader :version
      
      def test_update
        # fake methods for zentest, tested in all other tests
        assert(true)
      end
      
      def test_public_eh
        ce = JavaClass::ClassList::ClassEntry.new(self, 'pkg.Class', true, 0)
        assert(ce.public?)
        
        ce = JavaClass::ClassList::ClassEntry.new(self, 'pkg.Class', false, 0)
        assert(!ce.public?)
      end
      
      def test_version
        ce = JavaClass::ClassList::ClassEntry.new(self, 'pkg.Class', true, 0)
        assert_equal([0], ce.version)

        ce.update(1)
        assert_equal([0,1], ce.version)

        ce.update(2)
        assert_equal([0,1,2], ce.version)
      end
      
      def test_to_full_qualified_s_first
        ce = JavaClass::ClassList::ClassEntry.new(self, 'pkg.Class', true, 0)
        
        # new class in 0
        assert_equal("pkg.Class - \n", ce.to_full_qualified_s(0,0))
        # class only in 0, package in 1
        assert_equal("pkg.Class [only 0] - \n", ce.to_full_qualified_s(0,1))
        # class also in 1
        ce.update(1)
        assert_equal("pkg.Class - \n", ce.to_full_qualified_s(0,1))
        # dropped in 2
        assert_equal("pkg.Class [-1] - \n", ce.to_full_qualified_s(0,2)) 
        # class also in 2
        ce.update(2)
        assert_equal("pkg.Class - \n", ce.to_full_qualified_s(0,2))
      end
      
      def test_to_full_qualified_s_package
        ce = JavaClass::ClassList::ClassEntry.new(self, 'pkg.Class', false, 0)
        # new class in 0
        assert_equal("pkg.Class [p] - \n", ce.to_full_qualified_s(0,0))
        # class only in 0, package in 1
        assert_equal("pkg.Class [only 0p] - \n", ce.to_full_qualified_s(0,1))
        # class also in 1
        ce.update(1)
        assert_equal("pkg.Class [p] - \n", ce.to_full_qualified_s(0,1))
        # dropped in 2
        assert_equal("pkg.Class [-1p] - \n", ce.to_full_qualified_s(0,2)) 
        # class also in 2
        ce.update(2)
        assert_equal("pkg.Class [p] - \n", ce.to_full_qualified_s(0,2))
      end
      
      def test_to_full_qualified_s_later
        ce = JavaClass::ClassList::ClassEntry.new(self, 'pkg.Class', true, 1)
        
        # list is only for 1
        assert_equal("pkg.Class - \n", ce.to_full_qualified_s(1,1))
        # new class in 1
        assert_equal("pkg.Class [1] - \n", ce.to_full_qualified_s(0,1))
        # new class in 1, not in 2
        assert_equal("pkg.Class [only 1] - \n", ce.to_full_qualified_s(0,2))
        # new class in 1, also in 2
        ce.update(2)
        assert_equal("pkg.Class [1] - \n", ce.to_full_qualified_s(0,2))
        # dropped in 3
        assert_equal("pkg.Class [1-2] - \n", ce.to_full_qualified_s(0,3))
      end
      
      def test_to_full_qualified_s_later_package
        ce = JavaClass::ClassList::ClassEntry.new(self, 'pkg.Class', false, 1)
        
        # list is only for 1
        assert_equal("pkg.Class [1p] - \n", ce.to_full_qualified_s(1,1))
        # new class in 1
        assert_equal("pkg.Class [1p] - \n", ce.to_full_qualified_s(0,1))
        # new class in 1, not in 2
        assert_equal("pkg.Class [only 1p] - \n", ce.to_full_qualified_s(0,2))
        # new class in 1, also in 2
        ce.update(2)
        assert_equal("pkg.Class [1p] - \n", ce.to_full_qualified_s(0,2))
        # dropped in 3
        assert_equal("pkg.Class [1-2p] - \n", ce.to_full_qualified_s(0,3))
      end
      
      def test_to_package_shortcut_s
        ce = JavaClass::ClassList::ClassEntry.new(self, 'pkg2.Class2', true, 0)
        
        # new class in 0
        @version = [0] 
        assert_equal("   Class2 - \n", ce.to_package_shortcut_s)
        
        # class only in 0, package in 1
        @version = [0,1] 
        assert_equal("   Class2 [only 0] - \n", ce.to_package_shortcut_s)
        
        # class also in 1
        ce.update(1)
        assert_equal("   Class2 - \n", ce.to_package_shortcut_s)
        
        # class dropped in 2, package exists
        @version = [0,1,2] 
        assert_equal("   Class2 [-1] - \n", ce.to_package_shortcut_s)
        
        # class also in 2
        ce.update(2)
        assert_equal("   Class2 - \n", ce.to_package_shortcut_s)
      end
      
      def test_to_package_shortcut_s_package
        ce = JavaClass::ClassList::ClassEntry.new(self, 'pkg2.Class2', false, 0)
        
        # new class in 0
        @version = [0] 
        assert_equal("   Class2 [p] - \n", ce.to_package_shortcut_s)
        
        # class only in 0, package in 1
        @version = [0,1] 
        assert_equal("   Class2 [only 0p] - \n", ce.to_package_shortcut_s)
        
        # class also in 1
        ce.update(1)
        assert_equal("   Class2 [p] - \n", ce.to_package_shortcut_s)
        
        # class dropped in 2, package exists
        @version = [0,1,2] 
        assert_equal("   Class2 [-1p] - \n", ce.to_package_shortcut_s)
        
        # class also in 2
        ce.update(2)
        assert_equal("   Class2 [p] - \n", ce.to_package_shortcut_s)
      end
      
      def test_to_package_shortcut_s_later
        ce = JavaClass::ClassList::ClassEntry.new(self, 'pkg2.Class2', true, 1)
        
        # list is only for 1
        @version = [1] 
        assert_equal("   Class2 - \n", ce.to_package_shortcut_s)
        
        # new class in 1
        @version = [0,1] 
        assert_equal("   Class2 [1] - \n", ce.to_package_shortcut_s)
        
        # new class in 1, not in 2
        @version = [0,1,2] 
        assert_equal("   Class2 [only 1] - \n", ce.to_package_shortcut_s)
        
        # new class in 1, also in 2
        ce.update(2)
        assert_equal("   Class2 [1] - \n", ce.to_package_shortcut_s)
        
        # new class in 1 and 2, not in 3
        @version = [0,1,2,3] 
        assert_equal("   Class2 [1-2] - \n", ce.to_package_shortcut_s)
      end
      
      def test_to_package_shortcut_s_later_package
        ce = JavaClass::ClassList::ClassEntry.new(self, 'pkg2.Class2', false, 1)
        
        # list is only for 1
        @version = [1] 
        assert_equal("   Class2 [1p] - \n", ce.to_package_shortcut_s)
        
        # new class in 1
        @version = [0,1] 
        assert_equal("   Class2 [1p] - \n", ce.to_package_shortcut_s)
        
        # new class in 1, not in 2
        @version = [0,1,2] 
        assert_equal("   Class2 [only 1p] - \n", ce.to_package_shortcut_s)
        
        # new class in 1, also in 2
        ce.update(2)
        assert_equal("   Class2 [1p] - \n", ce.to_package_shortcut_s)
        
        # new class in 1 and 2, not in 3
        @version = [0,1,2,3] 
        assert_equal("   Class2 [1-2p] - \n", ce.to_package_shortcut_s)
      end
      
    end
  end
end