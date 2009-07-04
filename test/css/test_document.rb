require 'helper'

module CSSPool
  module CSS
    class TestDocument < CSSPool::TestCase
      def test_search
        doc = CSSPool.CSS('div > p { background: red; }')
        assert_equal 1, doc['div > p'].length
        assert_equal 1, doc['div > p'].first.declarations.length
      end
    end
  end
end
