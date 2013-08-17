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

      # with this feature, "and" is a reserved word. you can't use it as an ident, but you can as anything else
      def test_other_use_of_keyword
        doc = CSSPool.CSS <<-eocss
          /* and */
          .and { display: flexbox; content: " and ";}
          and { and: and; }
        eocss
      end

      def test_invalid_keyword_in_place_of_and_or
        exception_happened = false
        begin
          doc = CSSPool.CSS <<-eocss
            @supports ( display: flexbox ) xor ( display: block ) {
              body { display: flexbox; }
            }
          eocss
        rescue
          exception_happened = true
        end
        assert exception_happened
      end

      def test_invalid_keyword_in_place_of_not
        exception_happened = false
        begin
          doc = CSSPool.CSS <<-eocss
            @supports isnt ( display: flexbox ) {
              body { display: flexbox; }
            }
          eocss
        rescue
          exception_happened = true
        end
        assert exception_happened
      end
    end
  end
end
