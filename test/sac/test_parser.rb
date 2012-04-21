require 'helper'

module CSSPool
  module SAC
    class TestParser < CSSPool::TestCase
      def setup
        super
        @doc = MyDoc.new
        @css = <<-eocss
          @charset "UTF-8";
          @import url("foo.css") screen;
          /* This is a comment */
          div a.foo, #bar, * { background: red; }
          div#a, a.foo, a:hover, a[href][int="10"]{ background: red; }
          ::selection, q:before { background: red; }
        eocss
        @parser = CSSPool::SAC::Parser.new(@doc)
        @parser.parse(@css)
      end

      def test_start_and_end_called_with_the_same
        assert_equal @doc.start_selectors, @doc.end_selectors
      end

      def test_parse_no_doc
        parser = CSSPool::SAC::Parser.new
        parser.parse(@css)
      end

      def test_start_document
        assert_equal [true], @doc.start_documents
      end

      def test_end_document
        assert_equal [true], @doc.end_documents
      end

      def test_charset
        assert_equal("UTF-8", @doc.charsets.first.first)
      end

      def test_import_style
        styles = @doc.import_styles.first
        assert_equal "screen", styles.first.first.value
        assert_equal "foo.css", styles[1].value
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
      end

      def test_additional_selector_list
        selectors_for_rule = @doc.start_selectors.first
        selector = selectors_for_rule.first # => div a.foo
        simple_selector = selector.simple_selectors[1] # => a.foo
        assert additional_selectors = simple_selector.additional_selectors
        assert_equal 1, additional_selectors.length
      end

      def test_additional_selector_class_name
        selectors_for_rule = @doc.start_selectors.first
        selector = selectors_for_rule.first # => div a.foo
        simple_selector = selector.simple_selectors[1] # => a.foo
        assert additional_selectors = simple_selector.additional_selectors
        foo_class = additional_selectors.first
        assert_equal 'foo', foo_class.name
      end

      # div#a, a.foo, a:hover, a[href='watever'] { background: red; }
      def test_id_additional_selector
        selectors_for_rule = @doc.start_selectors[1]
        selector = selectors_for_rule.first # => div#a
        simple_selector = selector.simple_selectors.first # => div#a
        assert_equal 'a', simple_selector.additional_selectors.first.name
      end

      # div#a, a.foo, a:hover, a[href][int="10"]{ background: red; }
      def test_pseudo_additional_selector
        selectors_for_rule = @doc.start_selectors[1]
        selector = selectors_for_rule[2] # => 'a:hover'
        simple_selector = selector.simple_selectors.first # => a:hover
        assert_equal 'hover', simple_selector.additional_selectors.first.name
        assert_nil simple_selector.additional_selectors.first.extra
      end

      # div#a, a.foo, a:hover, a[href][int="10"]{ background: red; }
      def test_attribute_selector
        selectors_for_rule = @doc.start_selectors[1]
        selector = selectors_for_rule[3] # => a[href][int="10"]
        simple_selector = selector.simple_selectors.first

        assert_equal 'href', simple_selector.additional_selectors.first.name
        assert_nil simple_selector.additional_selectors.first.value
        assert_equal 1, simple_selector.additional_selectors.first.match_way

        assert_equal 'int', simple_selector.additional_selectors[1].name
        assert_equal '10', simple_selector.additional_selectors[1].value
        assert_equal 2, simple_selector.additional_selectors[1].match_way
      end

      def test_pseudo_element_additional_selector
        selectors_for_rule = @doc.start_selectors[2]
        selector = selectors_for_rule[0]

        simple_selector = selector.simple_selectors[0] # ::selection
        assert_equal 'selection', simple_selector.additional_selectors.first.name
        assert_nil simple_selector.additional_selectors.first.css2

        selector = selectors_for_rule[1]
        simple_selector = selector.simple_selectors[0] # q.before
        assert_equal 'before', simple_selector.additional_selectors.first.name
        assert_equal true, simple_selector.additional_selectors.first.css2
      end

    end
  end
end
