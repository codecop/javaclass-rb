require File.dirname(__FILE__) + '/setup'
require 'javaclass/classfile/constant_pool'

module TestJavaClass
  module TestClassFile

    class TestConstantPool < Test::Unit::TestCase

      # 1.6.0_11 javap.exe output of test class, only tweaked the float value a bit...
      JAVAP_OUTPUT = '  Constant pool:
const #1 = Method       #15.#33;        //  java/lang/Object."<init>":()V
const #2 = String       #34;    //  String field
const #3 = Field        #14.#35;        //  ConstantPoolTest.stringField:Ljava/lang/String;
const #4 = InterfaceMethod      #16.#36;        //  java/lang/Runnable.run:()V
const #5 = Field        #14.#37;        //  ConstantPoolTest.intField:I
const #6 = float        3.14158995322368e+22f;
const #7 = Field        #14.#38;        //  ConstantPoolTest.floatField:F
const #8 = long 99999999l;
const #10 = Field       #14.#39;        //  ConstantPoolTest.longField:J
const #11 = double      3.14159265258979e-208d;
const #13 = Field       #14.#40;        //  ConstantPoolTest.doubleField:D
const #14 = class       #41;    //  ConstantPoolTest
const #15 = class       #42;    //  java/lang/Object
const #16 = class       #43;    //  java/lang/Runnable
const #17 = Asciz       stringField;
const #18 = Asciz       Ljava/lang/String;;
const #19 = Asciz       intField;
const #20 = Asciz       I;
const #21 = Asciz       ConstantValue;
const #22 = int 42;
const #23 = Asciz       floatField;
const #24 = Asciz       F;
const #25 = Asciz       longField;
const #26 = Asciz       J;
const #27 = Asciz       doubleField;
const #28 = Asciz       D;
const #29 = Asciz       <init>;
const #30 = Asciz       ()V;
const #31 = Asciz       Code;
const #32 = Asciz       run;
const #33 = NameAndType #29:#30;//  "<init>":()V
const #34 = Asciz       String field;
const #35 = NameAndType #17:#18;//  stringField:Ljava/lang/String;
const #36 = NameAndType #32:#30;//  run:()V
const #37 = NameAndType #19:#20;//  intField:I
const #38 = NameAndType #23:#24;//  floatField:F
const #39 = NameAndType #25:#26;//  longField:J
const #40 = NameAndType #27:#28;//  doubleField:D
const #41 = Asciz       ConstantPoolTest;
const #42 = Asciz       java/lang/Object;
const #43 = Asciz       java/lang/Runnable;'

      def setup
        @cp = JavaClass::ClassFile::ConstantPool.new(load_class('constant_pool/ConstantPoolTest'))
      end

      def test_index
        assert_equal('Method', @cp[1].name)
        assert_equal('Field', @cp[10].name)
      end

      def test_size
        assert_equal(331, @cp.size)
      end

      def test_item_count
        assert_equal(43, @cp.item_count)
      end

      def test_dump
        # puts @cp.dump.join("\n")
        assert_equal(JAVAP_OUTPUT.gsub(/ +/, ' ').gsub(/"</, '<').gsub(/>"/, '>'), @cp.dump.join("\n").gsub(/( |\t)+/,' '))
      end

      def test_items
        pool = @cp.items
        assert_equal(41, pool.size) # 2 double
        assert_equal('Method', pool[0].name)
        assert_equal('stringField', pool[14].value)
      end

      def test_find
        found = @cp.find(JavaClass::ClassFile::ConstantPool::STRING_TAG)
        assert_equal(1, found.size)
        assert_equal('String', found[0].name)
        assert_equal(34, found[0].string_index)
      end

      def test_strings
        found = @cp.strings
        assert_equal(1, found.size)
        assert_equal('String', found[0].name)
      end

      def test_class_item
        assert_equal('ConstantPoolTest', @cp.class_item(14).to_s)
        assert_raise(RuntimeError) { @cp.class_item(13) }
      end

      def test_field_item
        assert_equal('ConstantPoolTest', @cp.field_item(3).class_name)
        assert_raise(RuntimeError) { @cp.field_item(4) }
      end

      def test_method_item
        assert_equal('java/lang/Object', @cp.method_item(1).class_name)
        assert_raise(RuntimeError) { @cp.method_item(3) }
      end

    end

  end
end