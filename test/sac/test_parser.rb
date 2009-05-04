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
        start = @doc.start_selectors.first
        assert start, "should have start selectors"
        assert_equal 1, start.simple_selectors.length
      end
    end
  end
end
