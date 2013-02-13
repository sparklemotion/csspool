require 'helper'

module CSSPool
  class TestSelector < CSSPool::TestCase

    def test_multiple_semicolons
      doc = CSSPool.CSS <<-eocss
        a { background: red;; color: blue; }
      eocss
      rs = doc.rule_sets.first
      assert_equal 2, rs.declarations.size
    end

    def test_leading_semicolon
      doc = CSSPool.CSS <<-eocss
        a { ; background: red; }
      eocss
      rs = doc.rule_sets.first
      assert_equal 1, rs.declarations.size
    end

    def test_no_trailing_semicolon
      doc = CSSPool.CSS <<-eocss
        a { background: red }
      eocss
      rs = doc.rule_sets.first
      assert_equal 1, rs.declarations.size
    end

    def test_only_semicolon
      doc = CSSPool.CSS <<-eocss
        a { ; }
      eocss
      rs = doc.rule_sets.first
      assert_equal 0, rs.declarations.size
    end

  end
end
