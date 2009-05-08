require 'helper'

module Crocodile
  module SAC
    class TestParser < Crocodile::TestCase
      def setup
        @doc = MyDoc.new
        @css = <<-eocss
          @charset "UTF-8";
          @import url("foo.css") screen;
          /* This is a comment */
          div a.foo, #bar, * { background: red; }
          div#a, a.foo, a:hover, a[href='watever'] { background: red; }
        eocss
        @parser = Crocodile::SAC::Parser.new(@doc)
        @parser.parse(@css)
      end

      def test_parse_no_doc
        parser = Crocodile::SAC::Parser.new
        parser.parse(@css)
      end

      def test_start_document
        assert_equal [true], @doc.start_documents
      end

      def test_end_document
        assert_equal [true], @doc.end_documents
      end

      def test_charset
        assert_equal(
          [["UTF-8", { :line => 1, :byte_offset => 10, :column => 11}]],
          @doc.charsets)
      end

      def test_import_style
        styles = @doc.import_styles.first
        assert_equal ["screen"], styles.first
        assert_equal "foo.css", styles[1]
        assert_nil styles[2]
      end

      def test_start_selector
        selectors_for_rule = @doc.start_selectors.first
        assert selectors_for_rule
        assert_equal 3, selectors_for_rule.length
      end

      def test_simple_selector
        selectors_for_rule = @doc.start_selectors.first
        selector = selectors_for_rule.first # => div a.foo
        assert_equal 2, selector.simple_selectors.length
        selector.simple_selectors.each do |ss|
          assert ss.parse_location
        end
      end

      def test_additional_selector_list
        selectors_for_rule = @doc.start_selectors.first
        selector = selectors_for_rule.first # => div a.foo
        simple_selector = selector.simple_selectors[1] # => a.foo
        assert additional_selectors = simple_selector.additional_selectors
        assert_equal 1, additional_selectors.length
      end
    end
  end
end
