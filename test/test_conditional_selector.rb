require File.dirname(__FILE__) + "/helper"

class ConditionalSelectorTest < SelectorTestCase
  def test_hash
    first = ConditionalSelector.new(1,1)
    second = ConditionalSelector.new(1,1)
    assert_equal first.hash, second.hash

    third = ConditionalSelector.new(1,2)
    assert_not_equal first.hash, third.hash

    fourth = ConditionalSelector.new(2,1)
    assert_not_equal first.hash, fourth.hash
  end

  def test_equals2
    first = ConditionalSelector.new(1,1)
    second = ConditionalSelector.new(1,1)
    assert_equal first, second

    third = ConditionalSelector.new(1,2)
    assert_not_equal first, third

    fourth = ConditionalSelector.new(2,1)
    assert_not_equal first, fourth
  end

  def test_equals_tilde
    attribute = AttributeCondition.new('class', 'foo', true)
    div = ElementSelector.new('div')
    sel = ConditionalSelector.new(div, attribute)

    node = Node.new('div')
    node.attributes = { 'class' => 'foo' }

    assert sel =~ node

    node.attributes = { 'class' => 'bar' }
    assert(!(sel =~ node))
  end
end
