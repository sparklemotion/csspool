require 'helper'

module CSSPool
  module CSS
    class TestDocumentQuery < CSSPool::TestCase

      def test_function
        doc = CSSPool.CSS <<-eocss
          @document domain("example.com") {
            * { color: blue; }
          }
        eocss
        assert_equal 1, doc.document_queries.size
        assert_equal 1, doc.document_queries[0].url_functions.size
        assert_equal CSSPool::Terms::Function, doc.document_queries[0].url_functions[0].class
        assert_equal 'domain', doc.document_queries[0].url_functions[0].name
        assert_equal 'example.com', doc.document_queries[0].url_functions[0].params[0].value
        assert_equal 1, doc.document_queries[0].rule_sets.size
      end

      def test_function_no_quote
        doc = CSSPool.CSS <<-eocss
          @document domain(example.com) {
            * { color: blue; }
          }
        eocss
        assert_equal 1, doc.document_queries.size
        assert_equal 1, doc.document_queries[0].url_functions.size
        assert_equal CSSPool::Terms::Function, doc.document_queries[0].url_functions[0].class
        assert_equal 'domain', doc.document_queries[0].url_functions[0].name
        assert_equal 'example.com', doc.document_queries[0].url_functions[0].params[0].value
        assert_equal 1, doc.document_queries[0].rule_sets.size
      end

      def test_multiple
        doc = CSSPool.CSS <<-eocss
          @document domain(example.com), url-prefix(http://example.com) {
            * { color: blue; }
          }
        eocss
        assert_equal 1, doc.document_queries.size
        assert_equal 2, doc.document_queries[0].url_functions.size
        assert_equal CSSPool::Terms::Function, doc.document_queries[0].url_functions[0].class
        assert_equal 'domain', doc.document_queries[0].url_functions[0].name
        assert_equal 'example.com', doc.document_queries[0].url_functions[0].params[0].value
        assert_equal CSSPool::Terms::Function, doc.document_queries[0].url_functions[1].class
        assert_equal 'url-prefix', doc.document_queries[0].url_functions[1].name
        assert_equal 'http://example.com', doc.document_queries[0].url_functions[1].params[0].value
        assert_equal 1, doc.document_queries[0].rule_sets.size
      end

      def test_url
        doc = CSSPool.CSS <<-eocss
          @document url("http://www.example.com") {
            * { color: blue; }
          }
        eocss
        assert_equal 1, doc.document_queries.size
        assert_equal 1, doc.document_queries[0].url_functions.size
        assert_equal CSSPool::Terms::URI, doc.document_queries[0].url_functions[0].class
        assert_equal 'http://www.example.com', doc.document_queries[0].url_functions[0].value
        assert_equal 1, doc.document_queries[0].rule_sets.size
      end

      def test_empty
        doc = CSSPool.CSS <<-eocss
          @document url("http://www.example.com") {
          }
        eocss
        assert_equal 1, doc.document_queries.size
        assert_equal true, doc.document_queries[0].rule_sets.empty?
      end
    end
  end
end
