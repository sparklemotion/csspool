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
end

