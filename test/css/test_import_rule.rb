require 'helper'

module CSSPool
  module CSS
    class TestImportRule < CSSPool::TestCase
      def test_import
        doc = CSSPool.CSS <<-eocss
          @import "foo.css";
        eocss

        assert_equal 1, doc.import_rules.length

        doc.import_rules.each do |ir|
          new_doc = ir.load do |url|
            assert_equal "foo.css", url
            "div { background: red; }"
          end
          assert new_doc
          assert_equal 1, new_doc.rule_sets.length
          assert_equal ir, new_doc.parent_import_rule
          assert_equal doc, new_doc.parent
        end
      end

      def test_import_with_media
        doc = CSSPool.CSS <<-eocss
          @import "foo.css" screen, print;
        eocss

        assert_equal 1, doc.import_rules.length
        doc.import_rules.each do |ir|
          new_doc = ir.load do |url|
            "div { background: red; }"
          end
        end
      end
    end
  end
end
