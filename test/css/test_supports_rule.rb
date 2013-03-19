require 'helper'

module CSSPool
  module CSS
    class TestSupportsRule < CSSPool::TestCase

      def test_basic
        doc = CSSPool.CSS <<-eocss
          @supports ( display: flexbox ) {
            body { display: flexbox; }
          }
        eocss
        assert_equal 1, doc.supports_rules.size
        assert_match '( display: flexbox )', doc.supports_rules[0].conditions
				assert_equal 1, doc.supports_rules[0].rule_sets.size
      end

      def test_not
        doc = CSSPool.CSS <<-eocss
          @supports not ( display: flexbox ) {
            body { display: flexbox; }
          }
        eocss
        assert_equal 1, doc.supports_rules.size
        assert_match 'not ( display: flexbox )', doc.supports_rules[0].conditions
				assert_equal 1, doc.supports_rules[0].rule_sets.size
      end

      def test_or
        doc = CSSPool.CSS <<-eocss
          @supports ( display: flexbox ) or ( display: block ) {
            body { display: flexbox; }
          }
        eocss
        assert_equal 1, doc.supports_rules.size
        assert_match '( display: flexbox ) or ( display: block )', doc.supports_rules[0].conditions
				assert_equal 1, doc.supports_rules[0].rule_sets.size
      end

      def test_and
        doc = CSSPool.CSS <<-eocss
          @supports ( display: flexbox ) and ( display: block ) {
            body { display: flexbox; }
          }
        eocss
        assert_equal 1, doc.supports_rules.size
        assert_match '( display: flexbox ) and ( display: block )', doc.supports_rules[0].conditions
				assert_equal 1, doc.supports_rules[0].rule_sets.size
      end

      def test_complex
        doc = CSSPool.CSS <<-eocss
          @supports ((display: inline) or (( display: flexbox ) and ( display: block ))) {
            body { display: flexbox; }
          }
        eocss
        assert_equal 1, doc.supports_rules.size
        assert_match '((display: inline) or (( display: flexbox ) and ( display: block ))', doc.supports_rules[0].conditions
				assert_equal 1, doc.supports_rules[0].rule_sets.size
      end

      def test_double_parens
        doc = CSSPool.CSS <<-eocss
          @supports ((display: flexbox)) {
            body { display: flexbox; }
          }
        eocss
        assert_equal 1, doc.supports_rules.size
        assert_match '((display: flexbox))', doc.supports_rules[0].conditions
				assert_equal 1, doc.supports_rules[0].rule_sets.size
      end

      def test_important
        doc = CSSPool.CSS <<-eocss
          @supports ( display: flexbox !important) {
            body { display: flexbox; }
          }
        eocss
        assert_equal 1, doc.supports_rules.size
        assert_match '( display: flexbox !important)', doc.supports_rules[0].conditions
				assert_equal 1, doc.supports_rules[0].rule_sets.size
      end

    end
  end
end
