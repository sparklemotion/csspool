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

      def test_start_stop
        assert_calls [[:start_document, []], [:end_document, []]],
          '@import "foo"'
      end

      def assert_calls calls, css
        @parser.scan_str css
        assert_equal calls, @doc.calls
      end
    end
  end
end
