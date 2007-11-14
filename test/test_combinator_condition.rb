require File.dirname(__FILE__) + "/helper"

class CombinatorConditionTest < ConditionTestCase
  def test_equals2
    first = CombinatorCondition.new(1,1)
    second = CombinatorCondition.new(1,1)
    assert_equal first, second

    third = CombinatorCondition.new(1,2)
    assert_not_equal first, third
  end
end
