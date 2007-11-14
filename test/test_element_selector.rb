require File.dirname(__FILE__) + "/helper"

class ElementSelectorTest < SelectorTestCase
  def test_equals2
    first = ElementSelector.new(1)
    second = ElementSelector.new(1)
    assert_equal first, second

    third = ElementSelector.new(2)
    assert_not_equal first, third
  end
end

