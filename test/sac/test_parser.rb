require 'helper'

module Crocodile
  module SAC
    class TestParser < Crocodile::TestCase
      def setup
        @doc = MyDoc.new
        @parser = Crocodile::SAC::Parser.new(@doc)
        @parser.parse(<<-eocss)
          @charset "UTF-8";
          a { background: red; }
        eocss
      end

      def test_parse_no_doc
        parser = Crocodile::SAC::Parser.new
        parser.parse(<<-eocss)
          @charset "UTF-8";
          a { background: red; }
        eocss
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
    end
  end
end
