require File.dirname(__FILE__) + '/setup'
require 'javaclass/gems/zip_file'

module TestJavaClass
  module TestGems

    class TestZipFile < Test::Unit::TestCase

      def setup
        @folder = "#{TEST_DATA_PATH}/zip_file"
      end

      def test_patch_for_invalid_flags
        assert_two_directories('commons-math-2.2-broken.zip')
        assert_two_directories('regenerated-with-7zip.zip')
        assert_two_directories('regenerated-with-jar.zip')
      end

      def assert_two_directories(zip_name)
        zip = JavaClass::Gems::ZipFile.new(File.join(@folder, zip_name))
        number = 0
        zip.entries { |entry|
          assert_not_nil(entry)
          assert(!entry.file?)
          number += 1
        }
        assert_equal(2, number)
      end
      
    end

  end
end
