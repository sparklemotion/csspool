require 'helper'

module CSSPool
  module Visitors
    class TestComparable < CSSPool::TestCase
      def equalitest css
        doc1 = CSSPool.CSS css
        doc2 = CSSPool.CSS css
        assert_equal doc1, doc2

        list1 = []
        list2 = []

        doc1.each { |node| list1 << node }
        doc2.each { |node| list2 << node }

        assert_equal list1, list2

        stack = [doc1]
        until stack.empty? do
          stack += stack.pop.children
        end

        assert_equal doc1.hash, doc2.hash
      end

      def test_not_equal
        doc1 = CSSPool.CSS 'div { border: foo(1, 2); }'
        assert_not_equal nil, doc1
      end

      def test_hash_range
        equalitest 'div { border: #123; }'
      end

      def test_div_with_id
        equalitest 'div#foo { border: #123; }'
      end

      def test_div_with_pseudo
        equalitest 'div:foo { border: #123; }'
      end

      def test_div_with_universal
        equalitest '* { border: #123; }'
      end

      def test_simple
        equalitest '.foo { border: #123; }'
      end

      def test_rgb
        equalitest 'div { border: rgb(1,2,3); }'
      end

      def test_rgb_with_percentage
        equalitest 'div { border: rgb(100%,2%,3%); }'
      end

      def test_negative_number
        equalitest 'div { border: -1px; }'
      end

      def test_positive_number
        equalitest 'div { border: 1px; }'
      end

      %w{
        1 1em 1ex 1px 1in 1cm 1mm 1pt 1pc 1% 1deg 1rad 1ms 1s 1Hz 1kHz
      }.each do |num|
        define_method(:"test_num_#{num}") do
          equalitest "div { border: #{num}; }"
        end
      end

      def test_string_term
        equalitest 'div { border: "hello"; }'
      end

      def test_inherit
        equalitest 'div { color: inherit; }'
      end

      def test_important
        equalitest 'div { color: inherit !important; }'
      end

      def test_function
        equalitest 'div { border: foo("hello"); }'
      end

      def test_uri
        equalitest 'div { border: url(http://tenderlovemaking.com/); }'
      end

      def test_import
        equalitest '@import "foo.css" screen, print;'
        equalitest '@import "foo.css";'
      end
    end
  end
end
