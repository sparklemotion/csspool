require 'helper'

module CSSPool
  module CSS
    class TestFontFace < CSSPool::TestCase

      def test_basic
        doc = CSSPool.CSS <<-eocss
          @font-face { font-weight: normal; }
        eocss
        assert_equal "@font-face {\n  font-weight: normal;\n}", doc.to_css
      end

      def test_before_document_rule
        CSSPool.CSS <<-eocss
          @font-face { font-weight: normal; }
          @document domain(example.com) {}
        eocss
      end

      def test_in_document_rule
        CSSPool.CSS <<-eocss
          @document domain(example.com) {
            @font-face { font-weight: normal; }
            #element { display: none; }
          }
        eocss
      end

    end
  end
end
