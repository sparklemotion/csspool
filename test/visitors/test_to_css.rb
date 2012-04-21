# encoding: utf-8
require 'helper'

module CSSPool
  module Visitors
    class TestToCSS < CSSPool::TestCase
      def test_font_serialization
        doc = CSSPool.CSS 'p { font: 14px/30px Tahoma; }'

        assert_equal 3, doc.rule_sets.first.declarations[0].expressions.length

        doc = CSSPool.CSS(doc.to_css)
        assert_equal 3, doc.rule_sets.first.declarations[0].expressions.length

        assert_equal 'font: 14px / 30px Tahoma;',
          doc.rule_sets.first.declarations.first.to_css.strip
      end

      # FIXME: this is a bug
      def test_ident_followed_by_not_ident
        doc = CSSPool.CSS 'p#div { color: #666; }'
        assert_equal 'p#div', doc.rule_sets.first.selectors.first.to_css

        # doc = CSSPool.CSS 'p #div { color: #666; }'
        # assert_equal 'p #div', doc.rule_sets.first.selectors.first.to_css

        doc = CSSPool.CSS 'p.c { color: #666; }'
        assert_equal 'p.c', doc.rule_sets.first.selectors.first.to_css

        # doc = CSSPool.CSS 'p .c { color: #666; }'
        # assert_equal 'p .c', doc.rule_sets.first.selectors.first.to_css

        doc = CSSPool.CSS 'a:hover { color: #666; }'
        assert_equal 'a:hover', doc.rule_sets.first.selectors.first.to_css

        # doc = CSSPool.CSS 'a :hover { color: #666; }'
        # assert_equal 'a :hover', doc.rule_sets.first.selectors.first.to_css

        doc = CSSPool.CSS 'p::selection { color: #666; }'
        assert_equal 'p::selection', doc.rule_sets.first.selectors.first.to_css

        # doc = CSSPool.CSS 'p ::selection { color: #666; }'
        # assert_equal 'p ::selection', doc.rule_sets.first.selectors.first.to_css
      end

      def test_hash_operator
        doc = CSSPool.CSS 'p { font: foo, #666; }'
        assert_equal 2, doc.rule_sets.first.declarations[0].expressions.length

        doc = CSSPool.CSS(doc.to_css)
        assert_equal 2, doc.rule_sets.first.declarations[0].expressions.length
      end

      def test_uri_operator
        doc = CSSPool.CSS 'p { font: foo, url(http://example.com/); }'
        assert_equal 2, doc.rule_sets.first.declarations[0].expressions.length

        doc = CSSPool.CSS(doc.to_css)
        assert_equal 2, doc.rule_sets.first.declarations[0].expressions.length
      end

      def test_string_operator
        doc = CSSPool.CSS 'p { font: foo, "foo"; }'
        assert_equal 2, doc.rule_sets.first.declarations[0].expressions.length

        doc = CSSPool.CSS(doc.to_css)
        assert_equal 2, doc.rule_sets.first.declarations[0].expressions.length
      end

      def test_function_operator
        doc = CSSPool.CSS 'p { font: foo, foo(1); }'
        assert_equal 2, doc.rule_sets.first.declarations[0].expressions.length

        doc = CSSPool.CSS(doc.to_css)
        assert_equal 2, doc.rule_sets.first.declarations[0].expressions.length
      end

      def test_rgb_operator
        doc = CSSPool.CSS 'p { font: foo, rgb(1,2,3); }'
        assert_equal 2, doc.rule_sets.first.declarations[0].expressions.length

        doc = CSSPool.CSS(doc.to_css)
        assert_equal 2, doc.rule_sets.first.declarations[0].expressions.length
      end

      def test_includes
        doc = CSSPool.CSS <<-eocss
          div[bar ~= 'adsf'] { background: red, blue; }
        eocss

        assert_equal 1, doc.rule_sets.first.selectors.first.simple_selectors.first.additional_selectors.length
        assert_equal 2, doc.rule_sets.first.declarations[0].expressions.length

        doc = CSSPool.CSS(doc.to_css)
        assert_equal 1, doc.rule_sets.first.selectors.first.simple_selectors.first.additional_selectors.length
        assert_equal 2, doc.rule_sets.first.declarations[0].expressions.length
      end

      def test_dashmatch
        doc = CSSPool.CSS <<-eocss
          div[bar |= 'adsf'] { background: red, blue; }
        eocss

        assert_equal 1, doc.rule_sets.first.selectors.first.simple_selectors.first.additional_selectors.length

        doc = CSSPool.CSS(doc.to_css)
        assert_equal 1, doc.rule_sets.first.selectors.first.simple_selectors.first.additional_selectors.length
      end

      def test_media
        doc = CSSPool.CSS <<-eocss
          @media print {
            div { background: red, blue; }
          }
        eocss
        assert_equal 1, doc.rule_sets.first.media.length

        doc = CSSPool.CSS(doc.to_css)
        assert_equal 1, doc.rule_sets.first.media.length
      end

      def test_multiple_media
        doc = CSSPool.CSS <<-eocss
          @media print, screen {
            div { background: red, blue; }
          }

          @media all {
            div { background: red, blue; }
          }
        eocss
        assert_equal 2, doc.rule_sets.first.media.length
        assert_equal 1, doc.rule_sets[1].media.length

        doc = CSSPool.CSS(doc.to_css)
        assert_equal 2, doc.rule_sets.first.media.length
        assert_equal 1, doc.rule_sets[1].media.length
      end

      def test_import
        doc = CSSPool.CSS <<-eocss
          @import "test.css";
          @import url("test.css");
          @import url("test.css") print, screen;
        eocss

        assert_equal 3, doc.import_rules.length
        assert_equal 2, doc.import_rules.last.media.length

        doc = CSSPool.CSS(doc.to_css)

        assert_equal 3, doc.import_rules.length
        assert_equal 2, doc.import_rules.last.media.length
      end

      def test_charsets
        doc = CSSPool.CSS <<-eocss
          @charset "UTF-8";
        eocss

        assert_equal 1, doc.charsets.length

        doc = CSSPool.CSS(doc.to_css)

        assert_equal 1, doc.charsets.length
      end

      def test_selector_attribute
        input_output = {
          "\"quotes\"" => "[title=\"\\\"quotes\\\"\"]",
        }
        input_output.each_pair do |input, output|
          node = Selectors::Attribute.new 'title', input, Selectors::Attribute::EQUALS
          assert_equal output, node.to_css
        end

        input_output = {
          " space" => "[\\ space=\"value\"]",
          "equal=" => "[equal\\==\"value\"]",
          "new\nline" => "[new\\00000aline=\"value\"]"
        }
        input_output.each_pair do |input, output|
          node = Selectors::Attribute.new input, 'value', Selectors::Attribute::EQUALS
          assert_equal output, node.to_css
        end
      end

      def test_selector_psuedo
        input_output = {
          "pseudo" => ":pseudo",
          "\"quotes\"" => ":\\000022quotes\\000022",
          "paren(" => ":paren\\(",
        }
        input_output.each_pair do |input, output|
          node = Selectors::PseudoClass.new input
          assert_equal output, node.to_css
        end

        input_output = {
          "" => ":pseudo()",
          "ident" => ":pseudo(ident)",
          " " => ":pseudo(\\ )",
          "\"quoted\"" => ":pseudo(\\000022quoted\\000022)"
        }
        input_output.each_pair do |input, output|
          node = Selectors::PseudoClass.new "pseudo", input
          assert_equal output, node.to_css
        end

        assert_equal "::before", Selectors::PseudoElement.new("before").to_css
        assert_equal ":before", Selectors::PseudoElement.new("before", true).to_css
      end

      def test_selector_other
        input_output = {
          "pseudo" => "pseudo",
          "\"quotes\"" => "\\000022quotes\\000022",
          "space " => "space\\ ",
          "new\nline" => "new\\00000aline"
        }
        input_output.each_pair do |input, output|
          node = Selectors::Type.new input
          assert_equal "#{output}", node.to_css
        end
        input_output.each_pair do |input, output|
          node = Selectors::Id.new input
          assert_equal "##{output}", node.to_css
        end
        input_output.each_pair do |input, output|
          node = Selectors::Class.new input
          assert_equal ".#{output}", node.to_css
        end
      end

      def test_property
        input_output = {
          "property" => "  property: value;",
          "colon:" => "  colon\\:: value;",
          "space " => "  space\\ : value;"
        }
        input_output.each_pair do |input, output|
          node = CSS::Declaration.new input, [Terms::Ident.new("value")], false, nil
          assert_equal output, node.to_css
        end
      end

      def test_function_term
        input_output = {
          "attr" => "attr(\"string\", ident)",
          "0" => "\\000030(\"string\", ident)",
          "a function" => "a\\ function(\"string\", ident)",
          "a(" => "a\\((\"string\", ident)",
        }
        input_output.each_pair do |input, output|
          node = Terms::Function.new input, [Terms::String.new("string"), Terms::Ident.new("ident", ',')]
          assert_equal output, node.to_css
        end
      end

      def test_uri_term
        input_output = {
          "http://example.com" => "url(\"http://example.com\")",
        }
        input_output.each_pair do |input, output|
          node = Terms::URI.new input
          assert_equal output, node.to_css
        end
      end

      def test_string_term
        input_output = {
          "basic" => "\"basic\"",
          "\"quotes\"" => "\"\\\"quotes\\\"\"",
          "…" => "\"…\"",
          "\n\r\f" => "\"\\a \\\r\\\f\""
        }
        input_output.each_pair do |input, output|
          node = Terms::String.new input
          assert_equal output, node.to_css
        end
      end

      def test_minification
        rawCSS = <<-eocss
          p {
            font: foo;
            color: #f00;
          }
        eocss

        doc = CSSPool.CSS rawCSS
        parsed_doc = doc.to_minified_css

        assert_equal "p { font: foo; color: #f00; }", parsed_doc
      end

      def test_minification_alt
        rawCSS = <<-eocss
          p {
            font: foo;
            color: #f00;
          }
        eocss

        doc = CSSPool.CSS rawCSS
        parsed_doc = doc.to_css :minify => true

        assert_equal "p { font: foo; color: #f00; }", parsed_doc
      end

    end
  end
end
