require File.dirname(__FILE__) + "/helper"

class ConditionTest < ConditionTestCase
  def test_equals2
    first = Condition.new(1)
    second = Condition.new(1)
    assert_equal first, second

    third = Condition.new(2)
    assert_not_equal first, third
    assert_not_equal first, 1
  end
end
