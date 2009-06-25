require 'helper'

module Crocodile
  module Visitors
    class TestToCSS < Crocodile::TestCase
      def test_includes
        doc = Crocodile.CSS <<-eocss
          div[bar ~= 'adsf'] { background: red, blue; }
        eocss

        assert_equal 1, doc.rule_sets.first.selectors.first.simple_selectors.first.additional_selectors.length

        doc = Crocodile.CSS(doc.to_css)
        assert_equal 1, doc.rule_sets.first.selectors.first.simple_selectors.first.additional_selectors.length
      end

      def test_dashmatch
        doc = Crocodile.CSS <<-eocss
          div[bar |= 'adsf'] { background: red, blue; }
        eocss

        assert_equal 1, doc.rule_sets.first.selectors.first.simple_selectors.first.additional_selectors.length

        doc = Crocodile.CSS(doc.to_css)
        assert_equal 1, doc.rule_sets.first.selectors.first.simple_selectors.first.additional_selectors.length
      end

      def test_media
        doc = Crocodile.CSS <<-eocss
          @media print {
            div { background: red, blue; }
          }
        eocss
        assert_equal 1, doc.rule_sets.first.media.length

        doc = Crocodile.CSS(doc.to_css)
        assert_equal 1, doc.rule_sets.first.media.length
      end

      def test_multiple_media
        doc = Crocodile.CSS <<-eocss
          @media print, screen {
            div { background: red, blue; }
          }

          @media all {
            div { background: red, blue; }
          }
        eocss
        assert_equal 2, doc.rule_sets.first.media.length
        assert_equal 1, doc.rule_sets[1].media.length

        doc = Crocodile.CSS(doc.to_css)
        assert_equal 2, doc.rule_sets.first.media.length
        assert_equal 1, doc.rule_sets[1].media.length
      end

      def test_import
        doc = Crocodile.CSS <<-eocss
          @import "test.css";
          @import url("test.css");
          @import url("test.css") print, screen;
        eocss

        assert_equal 3, doc.import_rules.length
        assert_equal 2, doc.import_rules.last.media.length

        doc = Crocodile.CSS(doc.to_css)

        assert_equal 3, doc.import_rules.length
        assert_equal 2, doc.import_rules.last.media.length
      end

      def test_charsets
        doc = Crocodile.CSS <<-eocss
          @charset "UTF-8";
        eocss

        assert_equal 1, doc.charsets.length

        doc = Crocodile.CSS(doc.to_css)

        assert_equal 1, doc.charsets.length
      end
    end
  end
end
