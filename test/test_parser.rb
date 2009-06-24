require 'helper'

module Crocodile
  class TestParser < Crocodile::TestCase
    def test_doc_charset
      doc = Crocodile.CSS <<-eocss
        @charset "UTF-8";
        @import url("foo.css") screen;
        div#a, a.foo, a:hover, a[href][int="10"]{ background: red; }
      eocss
      assert_equal 'UTF-8', doc.charsets.first.name
    end

    def test_doc_parser
      doc = Crocodile.CSS <<-eocss
        @charset "UTF-8";
        div#a, a.foo, a:hover, a[href][int="10"]{ background: red; }
      eocss

      assert_equal 1, doc.rule_sets.length
      rule_set = doc.rule_sets.first
      assert_equal 4, rule_set.selectors.length
      assert_equal 1, rule_set.declarations.length
      assert_equal 'background', rule_set.declarations.first.property
    end

    def test_media
      doc = Crocodile.CSS <<-eocss
        @media print {
          div { background: red, blue; }
        }
      eocss
      assert_equal 1, doc.rule_sets.first.media.length
    end

    def test_universal_to_css
      doc = Crocodile.CSS <<-eocss
        * { background: red, blue; }
      eocss
      assert_match '*', doc.to_css
    end

    def test_doc_to_css
      doc = Crocodile.CSS <<-eocss
        div#a, a.foo, a:hover, a[href][int="10"]{ background: red, blue; }
      eocss
      assert_match 'div#a, a.foo, a:hover, a[href][int="10"]', doc.to_css
      assert_match 'background: red, blue;', doc.to_css
    end

    def test_doc_desc_to_css
      doc = Crocodile.CSS <<-eocss
        div > a { background: #123; }
      eocss
      assert_match 'div > a', doc.to_css
    end

    def test_doc_pseudo_to_css
      doc = Crocodile.CSS <<-eocss
        :hover { background: #123; }
      eocss
      assert_match ':hover', doc.to_css
    end

    def test_doc_id_to_css
      doc = Crocodile.CSS <<-eocss
        #hover { background: #123; }
      eocss
      assert_match '#hover', doc.to_css
    end

    def test_important
      doc = Crocodile.CSS <<-eocss
        div > a { background: #123 !important; }
      eocss
      assert_match '!important', doc.to_css
    end

    def test_doc_func_to_css
      doc = Crocodile.CSS <<-eocss
        div { border: foo(1, 2); }
      eocss
      assert_match('foo(1.0, 2.0)', doc.to_css)
    end
  end
end
