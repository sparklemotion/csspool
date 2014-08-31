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

    def test_vendor_prefix_math_simple
      doc = CSSPool.CSS <<-eocss
        a { top: -webkit-calc(100% + 15px) }
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

    def test_space_after_param
      CSSPool.CSS <<-eocss
        a { left: calc((100% - 48.5em) * 0.4 + 0.4em); }
      eocss
    end

    def test_space_before_param
      CSSPool.CSS <<-eocss
        a { left: calc(0.4 * (100% - 48.5em) + 0.4em); }
      eocss
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
