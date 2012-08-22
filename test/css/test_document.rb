require 'helper'
module CSSPool
  module CSS
    class TestDocument < CSSPool::TestCase
      def test_file_open
        doc = File.open("#{ASSET_DIR}/test.css") do |f|
          CSSPool.CSS f
        end

        assert_equal 1, doc['.test'].length
      end

      def test_search
        doc = CSSPool.CSS("div > p { background: red; }\n")
        assert_equal 1, doc['div > p'].length
        assert_equal 1, doc['div > p'].first.declarations.length
      end
    end
  end
end
