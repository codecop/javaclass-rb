require File.dirname(__FILE__) + '/setup'
require 'javaclass/constant_pool'

module TestJavaClass
  
  class TestConstantPool < Test::Unit::TestCase
    
    PUBLIC = File.expand_path("#{TEST_DATA_PATH}/PublicClass.class")
    
    def setup
      @cp = JavaClass::ConstantPool.new(File.open(PUBLIC, 'rb') {|io| io.read } )
    end
    
    def test_item_count
      assert_equal(16, @cp.item_count)
    end
    
    def test_dump
      puts @cp.dump
      #const #1 = Method       #3.#13; //  java/lang/Object."<init>":()V
      #const #2 = class        #14;    //  packagename/PublicClass
      #const #3 = class        #15;    //  java/lang/Object
      #const #4 = class        #16;    //  packagename/PublicClass$InnerClass
      #const #5 = Asciz        InnerClass;
      #const #6 = Asciz        InnerClasses;
      #const #7 = Asciz        <init>;
      #const #8 = Asciz        ()V;
      #const #9 = Asciz        Code;
      #const #10 = Asciz       LineNumberTable;
      #const #11 = Asciz       SourceFile;
      #const #12 = Asciz       PublicClass.java;
      #const #13 = NameAndType #7:#8;//  "<init>":()V
      #const #14 = Asciz       packagename/PublicClass;
      #const #15 = Asciz       java/lang/Object;
      #const #16 = Asciz       packagename/PublicClass$InnerClass;    
    end
    
  end
  
end