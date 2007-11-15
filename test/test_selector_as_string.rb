require File.dirname(__FILE__) + "/helper"

class SelectorAsStringTest < Test::Unit::TestCase
  def setup
    @sac = CSS::SAC::Parser.new()
    class << @sac.document_handler
      attr_accessor :selectors
      def start_selector(selectors)
        @selectors = selectors
      end
    end
  end

  def test_equal2
    @sac.parse('h1 > h2 { }')
    selectors = @sac.document_handler.selectors
    @sac.document_handler.selectors = []

    @sac.parse('h1 > h2 { }')
    selectors2 = @sac.document_handler.selectors

    assert_equal selectors, selectors2
  end

  def test_any_node_selector
    @sac.parse('* { }')
    selectors = @sac.document_handler.selectors
    assert_equal(1, selectors.length)
    assert_equal('*', selectors.first.to_css)
  end

  def test_element_node_selector
    @sac.parse('h1 { }')
    selectors = @sac.document_handler.selectors
    assert_equal(1, selectors.length)
    assert_equal('h1', selectors.first.to_css)
  end

  def test_element_node_conditional_selector
    @sac.parse('h1.awesome { }')
    selectors = @sac.document_handler.selectors
    assert_equal(1, selectors.length)
    assert_equal('h1.awesome', selectors.first.to_css)
  end

  def test_element_node_conditional
    @sac.parse('.awesome { }')
    selectors = @sac.document_handler.selectors
    assert_equal(1, selectors.length)
    assert_equal('.awesome', selectors.first.to_css)
  end

  def test_element_node_conditional_selector_id
    @sac.parse('h1#awesome { }')
    selectors = @sac.document_handler.selectors
    assert_equal(1, selectors.length)
    assert_equal('h1#awesome', selectors.first.to_css)
  end

  def test_selector_attribute
    @sac.parse('h1[class=foo] { }')
    selectors = @sac.document_handler.selectors
    assert_equal(1, selectors.length)
    assert_equal('h1[class=foo]', selectors.first.to_css)
  end

  def test_combinator_selector
    @sac.parse('h1[class=foo].aaron { }')
    selectors = @sac.document_handler.selectors
    assert_equal(1, selectors.length)
    assert_equal('h1[class=foo].aaron', selectors.first.to_css)
  end

  def test_descendant_selectors
    @sac.parse('div h1 { }')
    selectors = @sac.document_handler.selectors
    assert_equal(1, selectors.length)
    assert_equal('div h1', selectors.first.to_css)
  end

  def test_direct_descendant_selectors
    @sac.parse('div > h1 { }')
    selectors = @sac.document_handler.selectors
    assert_equal(1, selectors.length)
    assert_equal('div > h1', selectors.first.to_css)
  end

  def test_direct_sibling_selectors
    @sac.parse('div + h1 { }')
    selectors = @sac.document_handler.selectors
    assert_equal(1, selectors.length)
    assert_equal('div + h1', selectors.first.to_css)
  end
end
