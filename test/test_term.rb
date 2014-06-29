require 'helper'

module CSSPool
  class TestTerm < CSSPool::TestCase

    def test_math_simple
      doc = CSSPool.CSS <<-eocss
        a { top: calc(100% + 15px) }
      eocss
      rs = doc.rule_sets.first
      assert_equal '100% + 15px', rs.declarations.first.expressions.first.expression
    end

    def test_math_complex
      doc = CSSPool.CSS <<-eocss
        a { top: calc(100%/3 - 2*1em - 2*1px) }
      eocss
      rs = doc.rule_sets.first
      assert_equal '100%/3 - 2*1em - 2*1px', rs.declarations.first.expressions.first.expression
    end

    def test_math_with_params
      doc = CSSPool.CSS <<-eocss
        a { top: calc((1em + 16px) / 2) }
      eocss
      rs = doc.rule_sets.first
      assert_equal '(1em + 16px)/2', rs.declarations.first.expressions.first.expression
    end

    def test_negative_multiplication
      doc = CSSPool.CSS <<-eocss
        a { top: calc(1.4 * -8px) }
      eocss
      rs = doc.rule_sets.first
      assert_equal '1.4*-8px', rs.declarations.first.expressions.first.expression
    end

    def test_two_in_a_row
      doc = CSSPool.CSS <<-eocss
        a { background-size: calc(-2px + 100%) calc(-2px + 100%); }
      eocss
      rs = doc.rule_sets.first
      assert_equal '-2px + 100%', rs.declarations.first.expressions.first.expression
    end

    def test_function_no_params
      CSSPool.CSS <<-eocss
        a { -webkit-filter: invert() }
      eocss
    end
  end
end
