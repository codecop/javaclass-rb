require File.dirname(__FILE__) + '/setup'
require 'javaclass/classlist/list'

module TestJavaClass
  module TestClassList
    
    class TestList < Test::Unit::TestCase
      
      PACKAGE_CLASS = 'packagename/PackageClass.class'
      PUBLIC_CLASS = 'packagename/PublicClass.class'
      PUBLIC_INTERFACE = 'packagename/PublicInterface.class'
      
      def setup
        @list = JavaClass::ClassList::List.new
      end
      
      def test_add_class
        # fake methods for zentest, tested in all other tests
        assert(true)
      end
      
      def test_packages
        @list.add_class(PACKAGE_CLASS, false, 0)
        @list.add_class(PUBLIC_CLASS, true, 0)
        
        @list.add_class(PUBLIC_CLASS, true, 1)
        @list.add_class(PUBLIC_INTERFACE, true, 1)
        
        packages = @list.packages
        assert_equal(1, packages.size)
        assert_equal('packagename', packages[0].name)
        assert_equal([0,1], packages[0].version)
      end
      
      def test_old_access_list
        @list.add_class(PACKAGE_CLASS, false, 0)
        @list.add_class(PUBLIC_CLASS, true, 0)
        assert_equal(["packagename.PackageClass [p] - \n"], @list.old_access_list)
        
        @list.add_class(PACKAGE_CLASS, false, 1)
        @list.add_class(PUBLIC_CLASS, true, 1)
        @list.add_class(PUBLIC_INTERFACE, false, 1)
        assert_equal(["packagename.PublicInterface [1p] - \n"], @list.old_access_list)
      end
      
      def test_plain_class_list
        @list.add_class(PACKAGE_CLASS, false, 0)
        @list.add_class(PUBLIC_CLASS, true, 1)
        assert_equal(["packagename.PackageClass\n", "packagename.PublicClass\n"], @list.plain_class_list)
      end
      
      def test_plain_class_list_block_given
        @list.add_class(PACKAGE_CLASS, false, 0)
        @list.add_class(PUBLIC_CLASS, true, 1)
        assert_equal(["packagename.PublicClass\n"], @list.plain_class_list { |c| c.public? })
      end
      
      def test_full_class_list
        @list.add_class(PACKAGE_CLASS, false, 0)
        @list.add_class(PUBLIC_CLASS, true, 0)
        
        @list.add_class(PACKAGE_CLASS, false, 1)
        @list.add_class(PUBLIC_CLASS, true, 1)
        @list.add_class(PUBLIC_INTERFACE, true, 1)
        
        @list.add_class(PACKAGE_CLASS, false, 2)
        @list.add_class(PUBLIC_INTERFACE, true, 2)
        
        expected = [
          "packagename.PackageClass [p] - \n", 
          "packagename.PublicClass [-1] - \n",
          "packagename.PublicInterface [1] - \n"
        ]
        result = @list.full_class_list
        assert_equal(expected, result)
      end
      
      def test_parse_line
        expected = [
          "packagename.PackageClass [p] - \n", 
          "packagename.PublicClass [-1] - \n",
          "packagename.PublicInterface [1] - \n"
        ]
        
        expected.each {|line| @list.parse_line(line, 2) }
        result = @list.full_class_list
        assert_equal(expected, result)
      end
      
      def test_version 
        @list.parse_line("javax.swing.HeaderParser [1] - \n", 1)
        @list.parse_line("javax.swing.HeaderParser [only 2] - \n", 3)
        assert_equal([1,2], @list.version)
      end
      
      def test_first_last_versions
        @list.add_class(PUBLIC_CLASS, true, 0)
        @list.add_class(PUBLIC_CLASS, true, 1)
        @list.add_class(PUBLIC_INTERFACE, true, 2)
        assert_equal([0,2], @list.first_last_versions)
      end
      
      def test_size
        @list.add_class(PUBLIC_CLASS, true, 0)
        assert_equal(1, @list.size)
        @list.add_class(PUBLIC_CLASS, true, 1)
        assert_equal(1, @list.size)
        
        @list.add_class(PUBLIC_INTERFACE, true, 2)
        assert_equal(2, @list.size)
      end
      
      def test_version_throws
        @list.parse_line("javax.swing.HeaderParser [1] - \n", 4)
        assert_raise(RuntimeError) do 
          @list.parse_line("javax.swing.HeaderParser [only 2p] - \n", 4)
          # occurs because 1-4 is already set in versions, so we cant set 2 again
        end
        puts 'last warning "update class HeaderParser..." ^^^ is expected'
      end
      
    end
  end
end
