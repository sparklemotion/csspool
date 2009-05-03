require 'helper'

module Crocodile
  module SAC
    class TestParser < Crocodile::TestCase
      def setup
        @doc = MyDoc.new
        @parser = Crocodile::SAC::Parser.new(@doc)
      end

      def test_parse_no_doc
        parser = Crocodile::SAC::Parser.new
        parser.parse(<<-eocss)
          a { background: red; }
        eocss
      end

      def test_start_document
        @parser.parse(<<-eocss)
          a { background: red; }
        eocss
        assert_equal [true], @doc.start_documents
      end

      def test_end_document
        @parser.parse(<<-eocss)
          a { background: red; }
        eocss
        assert_equal [true], @doc.end_documents
      end
    end
  end
end
