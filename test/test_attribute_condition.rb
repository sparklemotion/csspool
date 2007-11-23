require File.dirname(__FILE__) + "/helper"

class AttributeConditionTest < ConditionTestCase
  def test_hash
    first = AttributeCondition.new(1, 1, 1)
    second = AttributeCondition.new(1, 1, 1)
    assert_equal first.hash, second.hash

    third = AttributeCondition.new(2, 1, 1)
    assert_not_equal first.hash, third.hash
  end

  def test_equals2
    first = AttributeCondition.new(1, 1, 1)
    second = AttributeCondition.new(1, 1, 1)
    assert_equal first, second

    third = AttributeCondition.new(1,1,2)
    assert_not_equal first, third

    fourth = AttributeCondition.new(1,2,1)
    assert_not_equal first, fourth

    fifth = AttributeCondition.new(2,1,1)
    assert_not_equal first, fifth
  end

  def test_equals_tilde
    attribute = AttributeCondition.new('class', 'foo', true)
    node = Node.new('p')
    node.attributes = { 'class' => 'foo' }

    assert attribute =~ node

    node.attributes = { 'class' => 'bar' }
    assert(!(attribute =~ node))
    assert(!(attribute =~ 1))
  end
end
