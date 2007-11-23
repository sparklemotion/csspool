require File.dirname(__FILE__) + "/helper"

class SiblingSelectorTest < SelectorTestCase
  def test_hash
    first = SiblingSelector.new(1,1)
    second = SiblingSelector.new(1,1)
    assert_equal first.hash, second.hash

    third = SiblingSelector.new(1,2)
    assert_not_equal first.hash, third.hash
  end

  def test_equals2
    first = SiblingSelector.new(1,1)
    second = SiblingSelector.new(1,1)
    assert_equal first, second

    third = SiblingSelector.new(1,2)
    assert_not_equal first, third

    fourth = SiblingSelector.new(2,1)
    assert_not_equal first, fourth
  end

  def test_equals_tilde
    selector = ElementSelector.new('div')
    sibling = ElementSelector.new('p')
    sel = SiblingSelector.new(selector, sibling)

    sibling = Node.new('p', nil, nil, nil) 
    node = Node.new('div', nil, nil, sibling)
    assert sel =~ node

    sibling1 = Node.new('div', nil, nil, nil) 
    node1 = Node.new('p', nil, nil, sibling)
    assert(! (sel =~ node1))

    assert(! (sel =~ NoParentNode.new('div')))
    assert(! (sel =~ Node.new('div', nil, nil)))
  end
end

