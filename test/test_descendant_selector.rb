require File.dirname(__FILE__) + "/helper"

class DescendantSelectorTest < SelectorTestCase
  def test_hash
    first = DescendantSelector.new(1,1)
    second = DescendantSelector.new(1,1)
    assert_equal first.hash, second.hash

    third = DescendantSelector.new(1,2)
    assert_not_equal first.hash, third.hash

    fourth = DescendantSelector.new(2,1)
    assert_not_equal first.hash, fourth.hash
  end

  def test_equals2
    first = DescendantSelector.new(1,1)
    second = DescendantSelector.new(1,1)
    assert_equal first, second

    third = DescendantSelector.new(1,2)
    assert_not_equal first, third

    fourth = DescendantSelector.new(2,1)
    assert_not_equal first, fourth
  end

  def test_equals_tilde
    parent = ElementSelector.new('div')
    child = ElementSelector.new('p')
    sel = DescendantSelector.new(parent, child)

    node = parent_child_tree('div', 'p')
    assert sel =~ node

    node2 = parent_child_tree('body', 'div', 'p')
    assert sel =~ node2

    node3 = parent_child_tree('body', 'div', 'table', 'tr', 'td', 'p')
    assert sel =~ node3

    failing = parent_child_tree('p', 'div')
    assert(! (sel =~ failing))
    assert(! (sel =~ NoParentNode.new('div')))
    assert(! (sel =~ Node.new('div', nil, nil)))
  end

  def test_many_descendants
    @sac = CSS::SAC::Parser.new()
    class << @sac.document_handler
      attr_accessor :selectors
      alias :start_selector :selectors=
    end

    @sac.parse('div h1 h2 { }')
    selectors = @sac.document_handler.selectors
    assert_equal(1, selectors.length)

    sel = selectors.first
    node = parent_child_tree('body', 'div', 'p', 'h1', 'p', 'h2')
    assert sel =~ node
  end
end

