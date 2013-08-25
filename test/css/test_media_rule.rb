require 'helper'

# CSS @media - http://www.w3.org/TR/css3-mediaqueries/
module CSSPool
  module CSS
    class TestMediaRule < CSSPool::TestCase

      def test_type
        doc = CSSPool.CSS <<-eocss
          @media print {
            div { background: red, blue; }
          }
        eocss
        assert_equal 1, doc.rule_sets.first.media_query_list.length
      end

      def test_expression
        doc = CSSPool.CSS <<-eocss
          @media (min-width:400px) {
            div { background: red, blue; }
          }
        eocss
        assert_equal 1, doc.rule_sets.first.media_query_list.length
      end

      def test_expression_no_space
        doc = CSSPool.CSS <<-eocss
          @media(min-width:400px) {
            div { background: red, blue; }
          }
        eocss
        assert_equal 1, doc.rule_sets.first.media_query_list.length
      end

      def test_complex
        doc = CSSPool.CSS <<-eocss
          @media screen and (color), projection and (color) { }
        eocss
        assert_equal 2, doc.rule_sets.first.media_query_list.length
      end

      def test_type_not
        doc = CSSPool.CSS <<-eocss
          @media not print {
            div { background: red, blue; }
          }
        eocss
        assert_equal 1, doc.rule_sets.first.media_query_list.length
      end

      def test_type_only
        doc = CSSPool.CSS <<-eocss
          @media only print {
            div { background: red, blue; }
          }
        eocss
        assert_equal 1, doc.rule_sets.first.media_query_list.length
      end

      def test_in_document_query
        doc = CSSPool.CSS <<-eocss
          @document domain(example.com) {
          @media(max-height: 800px){.dashboard{position: absolute;}}
          }
        eocss
        assert_equal 1, doc.rule_sets.first.media_query_list.length
      end

      def test_invalid_media_query_list
        # needs to have space after 'and'
        css = <<-eocss
          @media all and(color) {
            div { background: red, blue; }
          }
        eocss
        assert_raises Racc::ParseError do
          CSSPool::CSS(css)
        end
      end

      # "and" is a reserved word in @media, but not elsewhere
      def test_other_use_of_keywords
        doc = CSSPool.CSS <<-eocss
          /* and */
          .and { display: flexbox; content: " and ";}
          and { and: and; }
        eocss
      end

    end
  end
end
