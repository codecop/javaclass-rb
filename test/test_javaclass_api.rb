require File.dirname(__FILE__) + '/setup'
require 'javaclass'

module TestJavaClass

  # Test the public API usage.
  class TestJavaClassAPI < Test::Unit::TestCase # ZenTest SKIP

    # See http://api.javaclass-rb.googlecode.com/hg/0.0.2/index.html
    def test_usage_002
      clazz = JavaClass.parse("#{TEST_DATA_PATH}/api/packagename/AccessFlagsTestPublic.class")
      assert_not_nil(clazz)
      assert_equal('50.0', clazz.version.to_s)
      assert_equal('packagename/AccessFlagsTestPublic', clazz.constant_pool.items[1].to_s)
      assert(clazz.access_flags.public?)
      assert_equal('packagename/AccessFlagsTestPublic', clazz.this_class.to_s)
      assert_equal('java/lang/Object', clazz.super_class.to_s)
      assert_equal('java/lang/Object.<init>:()V', clazz.references.referenced_methods[0].to_s)
    end

    # See http://api.javaclass-rb.googlecode.com/hg/0.0.3/index.html
    def test_usage_003
      clazz = JavaClass.load_fs("#{TEST_DATA_PATH}/api/packagename/AccessFlagsTestPublic.class")
      assert_not_nil(clazz)

      classpath = JavaClass.classpath("#{TEST_DATA_PATH}/api")
      clazz = JavaClass.load_cp('packagename/AccessFlagsTestPublic', classpath)
      assert_not_nil(clazz)

      assert_equal(50, clazz.version.major)
      assert_equal(0, clazz.version.minor)
      assert_equal('packagename/AccessFlagsTestPublic', clazz.constant_pool.items[1].to_s)
      assert(clazz.access_flags.public?)
      assert_equal('packagename/AccessFlagsTestPublic', clazz.this_class.to_s)
      assert_equal('packagename/AccessFlagsTestPublic.java', clazz.this_class.to_java_file)
      assert_equal('java/lang/Object', clazz.super_class.to_s)
      assert_equal('java.lang.Object', clazz.super_class.to_classname)
      assert_equal('java/lang/Object.<init>:()V', clazz.references.referenced_methods[0].to_s)
    end

  end

end
