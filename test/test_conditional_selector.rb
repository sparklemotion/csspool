require File.dirname(__FILE__) + "/helper"

class ConditionalSelectorTest < SelectorTestCase
  def test_equals2
    first = ConditionalSelector.new(1,1)
    second = ConditionalSelector.new(1,1)
    assert_equal first, second

    third = ConditionalSelector.new(1,2)
    assert_not_equal first, third

    fourth = ConditionalSelector.new(2,1)
    assert_not_equal first, fourth
  end
end
