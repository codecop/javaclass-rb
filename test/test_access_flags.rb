require File.dirname(__FILE__) + '/setup'
require 'javaclass/classfile/java_class_header'

module TestJavaClass
  
  class TestAccessFlags < Test::Unit::TestCase
    
    def setup
      @cls = {}
      %w[Public Package Abstract Interface Final Public$Inner Public$StaticInner Public$InnerInterface].each do |t| 
        eval("@#{t.sub(/Public\$/, '').downcase} = JavaClass::ClassFile::JavaClassHeader.new(load_class('access_flags/AccessFlagsTest#{t}')).access_flags") 
      end
    end
    
    def test_accessible_eh
      assert(@public.accessible?)
      assert(!@package.accessible?)
      assert(@abstract.accessible?)
      assert(@interface.accessible?)
      assert(@final.accessible?)
    end
    
    def test_public_eh
      assert(@public.public?)
    end    
    
    def test_interface_eh
      assert(!@public.interface?)
      assert(!@package.interface?)
      assert(!@abstract.interface?)
      assert(@interface.interface?)
      assert(!@final.interface?)
      assert(@innerinterface.interface?)
    end
    
    def test_abstract_eh
      assert(!@public.abstract?)
      assert(!@package.abstract?)
      assert(@abstract.abstract?)
      assert(@interface.abstract?)
      assert(!@final.abstract?)
      assert(@innerinterface.abstract?)
    end
    
    def test_final_eh
      assert(!@public.final?)
      assert(!@package.final?)
      assert(!@abstract.final?)
      assert(!@interface.final?)
      assert(@final.final?)
    end
    
#    def test_inner_eh
#      assert(!@public.inner?)
#      assert(!@package.inner?)
#      assert(!@abstract.inner?)
#      assert(!@interface.inner?)
#      assert(!@final.inner?)
#      assert(@inner.inner?)
#      assert(@staticinner.inner?)
#      assert(@innerinterface.inner?)
#    end
    
  end
  
end