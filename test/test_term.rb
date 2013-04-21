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

  end
end
