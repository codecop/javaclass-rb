require 'test/unit'
require 'test/unit/testcase'
require File.join(File.dirname(__FILE__), '..', 'examples', 'corpus')

class TestCorpus < Test::Unit::TestCase

  def test_regular_corpus
    c = Corpus[:HBD]
    assert_equal('E:\OfficeDateien\Corpus/Java6_Web(HBD_Online)', c.location)
    assert_equal('E:\OfficeDateien\Corpus/Java6_Web(HBD_Online)/classes', c.classes)
    assert_equal('E:\OfficeDateien\Corpus/Java6_Web(HBD_Online)/test-classes', c.testClasses)
    assert_equal(['at.herold'], c.packages)
    assert_equal('at.herold', c.package)
  end

  def test_regular_corpus_without_tests
    c = Corpus[:WF]
    assert_equal('E:\OfficeDateien\Corpus/Java2_Swing(WF_iMagine)', c.location)
    assert_equal('E:\OfficeDateien\Corpus/Java2_Swing(WF_iMagine)/classes', c.classes)
    assert_nil(c.testClasses)
    assert_equal(['at.workforce'], c.packages)
  end

  def test_regular_corpus_without_packages
    c = Corpus[:Harmony15]
    assert_equal([], c.packages)
  end

end

