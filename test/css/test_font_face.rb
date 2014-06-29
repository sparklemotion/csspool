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

    end
  end
end
