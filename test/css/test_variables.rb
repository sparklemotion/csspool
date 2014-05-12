require 'helper'

# CSS variables - http://dev.w3.org/csswg/css-variables/
module CSSPool
  module CSS
    class TestVariables < CSSPool::TestCase

      # just checking that there's no parse error
      def test_basic
        doc = CSSPool.CSS <<-eocss
          :root {
            --main-bg-color: brown;
          }
          .one {
            background-color: var(--main-bg-color);
          }
        eocss
      end
    end
  end
end
