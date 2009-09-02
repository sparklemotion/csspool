# -*- coding: utf-8 -*-

require "helper"

module CSSPool
  module CSS
    class TestParser < CSSPool::TestCase
      class MethodCatcher
        attr_reader :calls

        def initialize
          @calls = []
        end

        def method_missing name, *args
          @calls << [name, args]
        end
      end

      def setup
        super
        @doc = MethodCatcher.new
        @parser = Class.new(CSSPool::CSS::Tokenizer) {
          def initialize doc
            @document = doc
          end
        }.new(@doc)
      end

      def test_ruleset_div_attribute_equals_ident
        @parser.scan_str 'div[a = b] { }'
        assert_equal :start_selector, @doc.calls[1].first
        assert_equal :end_selector, @doc.calls[2].first
      end

      def test_ruleset_div_attribute_exists
        @parser.scan_str 'div[a] { }'
        assert_equal :start_selector, @doc.calls[1].first
        assert_equal :end_selector, @doc.calls[2].first
      end

      def test_ruleset_div_class
        @parser.scan_str 'div.foo { }'
        assert_equal :start_selector, @doc.calls[1].first
        assert_equal :end_selector, @doc.calls[2].first
      end

      def test_ruleset_div_hash
        @parser.scan_str 'div#foo { }'
        assert_equal :start_selector, @doc.calls[1].first
        assert_equal :end_selector, @doc.calls[2].first
      end

      def test_ruleset_div
        @parser.scan_str 'div { }'
        assert_equal :start_selector, @doc.calls[1].first
        assert_equal :end_selector, @doc.calls[2].first
      end

      def test_ruleset_star
        @parser.scan_str '* { }'
        assert_equal :start_selector, @doc.calls[1].first
        assert_equal :end_selector, @doc.calls[2].first
      end

      def test_import
        @parser.scan_str '@import "foo";'
        assert_equal [:import_style, [[], 'foo']], @doc.calls[1]
      end

      def test_import_medium
        @parser.scan_str '@import "foo" page;'
        assert_equal [:import_style, [['page'], 'foo']], @doc.calls[1]
      end

      def test_import_medium_multi
        @parser.scan_str '@import "foo" page, print;'
        assert_equal [:import_style, [['page', 'print'], 'foo']], @doc.calls[1]
      end

      def test_start_stop
        @parser.scan_str "@import 'foo';"
        assert_equal [:start_document, []], @doc.calls.first
        assert_equal [:end_document, []], @doc.calls.last
      end

      def test_charset
        @parser.scan_str '@charset "UTF-8";'
        assert_equal [:charset, ['UTF-8']], @doc.calls[1]
      end
    end
  end
end
