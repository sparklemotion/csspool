require File.dirname(__FILE__) + "/helper"

class SiblingSelectorTest < SelectorTestCase
  def test_equals2
    first = SiblingSelector.new(1,1)
    second = SiblingSelector.new(1,1)
    assert_equal first, second

    third = SiblingSelector.new(1,2)
    assert_not_equal first, third

    fourth = SiblingSelector.new(2,1)
    assert_not_equal first, fourth
  end
end

