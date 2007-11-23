require File.dirname(__FILE__) + "/helper"

class ElementSelectorTest < SelectorTestCase
  def test_hash
    first = ElementSelector.new(1)
    second = ElementSelector.new(1)
    assert_equal first.hash, second.hash

    third = ElementSelector.new(2)
    assert_not_equal first.hash, third.hash
  end

  def test_equals2
    first = ElementSelector.new(1)
    second = ElementSelector.new(1)
    assert_equal first, second

    third = ElementSelector.new(2)
    assert_not_equal first, third
  end

  def test_equals_tilde
    div = ElementSelector.new('div')
    node = Node.new
    node.name = 'div'

    assert div =~ node
    assert(!(div =~ nil))
  end
end

