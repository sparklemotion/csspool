require File.dirname(__FILE__) + "/helper"

class ChildSelectorTest < SelectorTestCase
  def test_equals2
    first = ChildSelector.new(1,1)
    second = ChildSelector.new(1,1)
    assert_equal first, second

    third = ChildSelector.new(1,2)
    assert_not_equal first, third

    fourth = ChildSelector.new(2,1)
    assert_not_equal first, fourth
  end
end
