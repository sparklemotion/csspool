require 'helper'

# CSS keyframes - http://dev.w3.org/csswg/css3-animations/#keyframes
module CSSPool
  module CSS
    class TestKeyframesRule < CSSPool::TestCase

      def test_empty
        doc = CSSPool.CSS <<-eocss
          @keyframes id {}
        eocss
        assert_equal 1, doc.keyframes_rules.size
        assert_equal 'id', doc.keyframes_rules.first.name
        assert_equal 0, doc.keyframes_rules.first.rule_sets.size
      end

      def test_from
        doc = CSSPool.CSS <<-eocss
          @keyframes id {
            from {
              top: 0;
            }
          }
        eocss
        assert_equal 1, doc.keyframes_rules.first.rule_sets.size
        assert_equal 'from', doc.keyframes_rules.first.rule_sets.first.keyText
        assert_equal 1, doc.keyframes_rules.first.rule_sets.first.declarations.size
      end

      def test_to
        doc = CSSPool.CSS <<-eocss
          @keyframes id {
            to {
              top: 0;
            }
          }
        eocss
        assert_equal 1, doc.keyframes_rules.first.rule_sets.size
        assert_equal 'to', doc.keyframes_rules.first.rule_sets.first.keyText
        assert_equal 1, doc.keyframes_rules.first.rule_sets.first.declarations.size
      end

      def test_percent
        doc = CSSPool.CSS <<-eocss
          @keyframes id {
            50% {
              top: 0;
            }
          }
        eocss
        assert_equal 1, doc.keyframes_rules.first.rule_sets.size
        assert_equal '50%', doc.keyframes_rules.first.rule_sets.first.keyText
        assert_equal 1, doc.keyframes_rules.first.rule_sets.first.declarations.size
      end

      def test_multiple_selector
        doc = CSSPool.CSS <<-eocss
          @keyframes id {
            from, to, 50% {
              top: 0;
            }
          }
        eocss
        assert_equal 1, doc.keyframes_rules.first.rule_sets.size
        assert_equal 'from, to, 50%', doc.keyframes_rules.first.rule_sets.first.keyText
        assert_equal 1, doc.keyframes_rules.first.rule_sets.first.declarations.size
      end

      def test_multiple_blocks
        doc = CSSPool.CSS <<-eocss
          @keyframes id {
            from {
              top: 0;
            }
            to {
              top: 0;
            }
          }
        eocss
        assert_equal 2, doc.keyframes_rules.first.rule_sets.size
      end

      def test_vendor_prefix
        doc = CSSPool.CSS <<-eocss
          @-moz-keyframes id {}
        eocss
        assert_equal 1, doc.keyframes_rules.size
        assert_equal 'id', doc.keyframes_rules.first.name
        assert_equal 0, doc.keyframes_rules.first.rule_sets.size
      end
    end
  end
end
