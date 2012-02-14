# encoding: utf-8
require 'helper'

module CSSPool
  module SAC
    class TestTerms < CSSPool::TestCase
      def setup
        @doc = MyDoc.new
        @parser = CSSPool::SAC::Parser.new(@doc)
      end

      def test_hash_range
        @parser.parse <<-eocss
          div { border: #123; }
        eocss
        hash = @doc.properties.first[1].first
        assert_equal '123', hash.value
      end

      def test_rgb
        @parser.parse <<-eocss
          div { border: rgb(1,2,3); }
        eocss
        color = @doc.properties.first[1].first
        assert_equal 1, color.red.value
        assert_equal 2, color.green.value
        assert_equal 3, color.blue.value
        assert_match('rgb(1, 2, 3)', color.to_css)
      end

      def test_rgb_with_percentage
        @parser.parse <<-eocss
          div { border: rgb(100%, 2%, 3%); }
        eocss
        color = @doc.properties.first[1].first
        assert_equal 100, color.red.value
        assert_equal 2, color.green.value
        assert_equal 3, color.blue.value
        assert_match('rgb(100%, 2%, 3%)', color.to_css)
      end

      def test_negative_number
        @parser.parse <<-eocss
          div { border: -1px; }
        eocss
        assert_equal 1, @doc.properties.length
        size = @doc.properties.first[1].first
        assert_equal :minus, size.unary_operator
        assert_equal 1, size.value
        assert_equal '-1px', size.to_s
        assert_equal '-1px', size.to_css
      end

      def test_positive_number
        @parser.parse <<-eocss
          div { border: 1px; }
        eocss
        assert_equal 1, @doc.properties.length
        size = @doc.properties.first[1].first
        assert_equal 1, size.value
        assert_equal '1px', size.to_s
      end

      %w{
        1 1em 1ex 1px 1in 1cm 1mm 1pt 1pc 1% 1deg 1rad 1ms 1s 1Hz 1kHz
      }.each do |num|
        define_method(:"test_num_#{num}") do
          @parser.parse <<-eocss
            div { border: #{num}; }
          eocss
          assert_equal 1, @doc.properties.length
          size = @doc.properties.first[1].first
          assert_equal 1, size.value
          assert_equal num, size.to_s
          assert_equal num, size.to_css
        end
      end

      def test_selector_attribute
        @parser.parse <<-eocss
          div[attr = value] { }
          div[attr\\== value] { }
          div[attr="\\"quotes\\""] { }
          div[attr = unicode\\ \\1D11E\\BF ] { }
        eocss

        attrs = @doc.end_selectors.flatten.map(&:simple_selectors).flatten.map(&:additional_selectors).flatten
        assert_equal 4, attrs.length

        attrs.shift.tap do |attr|
          assert_equal "attr", attr.name,
              "Interprets name."
          assert_equal "value", attr.value,
              "Interprets bare value."
        end

        assert_equal "attr=", attrs.shift.name,
            "Interprets identifier escapes."

        assert_equal "\"quotes\"", attrs.shift.value,
            "Interprets quoted values."

        assert_equal "unicode \360\235\204\236\302\277", attrs.shift.value,
            "Interprets unicode escapes."
      end

      def test_string_term
        @parser.parse <<-eocss
          div { content: "basic"; }
          div { content: "\\"quotes\\""; }
          div { content: "unicode \\1D11E\\BF "; }
          div { content: "contin\\\nuation"; }
          div { content: "new\\aline"; }
          div { content: "\\11FFFF "; }
        eocss
        terms = @doc.properties.map {|s| s[1].first}
        assert_equal 6, terms.length

        assert_equal 'basic', terms.shift.value,
            "Recognizes a basic string"

        assert_equal "\"quotes\"", terms.shift.value,
            "Recognizes strings containing quotes."

        assert_equal "unicode \360\235\204\236\302\277", terms.shift.value,
            "Interprets unicode escapes."

        assert_equal "continuation", terms.shift.value,
            "Supports line continuation."

        assert_equal "new\nline", terms.shift.value,
            "Interprets newline escape."

        assert_equal "\357\277\275", terms.shift.value,
            "Kills absurd characters."
      end

      def test_inherit
        @parser.parse <<-eocss
          div { color: inherit; }
        eocss
        assert_equal 1, @doc.properties.length
        string = @doc.properties.first[1].first
        assert_equal 'inherit', string.value
        assert_equal 'inherit', string.to_css
      end

      def test_important
        @parser.parse <<-eocss
          div { color: inherit !important; }
        eocss
        assert_equal 1, @doc.properties.length
        string = @doc.properties.first[1].first
        assert_equal 'inherit', string.value
        assert_equal 'inherit', string.to_css
      end

      def test_declaration
        @parser.parse <<-eocss
          div { property: value; }
          div { colon\\:: value; }
          div { space\\ : value; }
        eocss
        properties = @doc.properties.map {|s| s[0]}
        assert_equal 3, properties.length

        assert_equal 'property', properties.shift,
            "Recognizes basic function."

        assert_equal 'colon:', properties.shift,
            "Recognizes property with escaped COLON."

        assert_equal 'space ', properties.shift,
            "Recognizes property with escaped SPACE."
      end

      def test_function
        @parser.parse <<-eocss
          div { content: attr(\"value\", ident); }
          div { content: \\30(\"value\", ident); }
          div { content: a\\ function(\"value\", ident); }
          div { content: a\\((\"value\", ident); }
        eocss
        terms = @doc.properties.map {|s| s[1].first}
        assert_equal 4, terms.length

        assert_equal 'attr', terms.shift.name,
            "Recognizes basic function."

        assert_equal '0', terms.shift.name,
            "Recognizes numeric function."

        assert_equal 'a function', terms.shift.name,
            "Recognizes function with escaped SPACE."

        assert_equal 'a(', terms.shift.name,
            "Recognizes function with escaped LPAREN."
      end

      def test_uri
        @parser.parse <<-eocss
          div { background: url(http://example.com/); }
          div { background: url( http://example.com/ ); }
          div { background: url("http://example.com/"); }
          div { background: url( " http://example.com/ " ); }
          div { background: url(http://example.com/\\"); }
        eocss
        terms = @doc.properties.map {|s| s[1].first}
        assert_equal 5, terms.length

        assert_equal 'http://example.com/', terms.shift.value,
            "Recognizes bare URI."

        assert_equal 'http://example.com/', terms.shift.value,
            "Recognize URI with spaces"

        assert_equal 'http://example.com/', terms.shift.value,
            "Recognize quoted URI"

        assert_equal ' http://example.com/ ', terms.shift.value,
            "Recognize quoted URI"

        assert_equal 'http://example.com/"', terms.shift.value,
            "Recognizes bare URI with quotes"
      end
    end
  end
end
