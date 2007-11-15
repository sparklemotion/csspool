require File.dirname(__FILE__) + "/helper"

class DescendantSelectorTest < SelectorTestCase
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
end

