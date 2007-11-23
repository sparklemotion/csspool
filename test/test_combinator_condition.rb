require File.dirname(__FILE__) + "/helper"

class CombinatorConditionTest < ConditionTestCase
  def test_equals2
    first = CombinatorCondition.new(1,1)
    second = CombinatorCondition.new(1,1)
    assert_equal first, second

    third = CombinatorCondition.new(1,2)
    assert_not_equal first, third
  end

  def test_hash
    first = CombinatorCondition.new(1,1)
    second = CombinatorCondition.new(1,1)
    assert_equal first.hash, second.hash

    third = CombinatorCondition.new(1,2)
    assert_not_equal first.hash, third.hash
  end

  def test_equals_tilde
    first = ClassCondition.new('foo')
    second = AttributeCondition.new('name', 'aaron', true)
    combinator_condition = CombinatorCondition.new(first, second)

    node = Node.new('p')
    node.attributes = { 'class' => 'foo', 'name' => 'aaron' }

    assert combinator_condition =~ node

    node.attributes = { 'class' => 'bar', 'name' => 'aaron' }
    assert(!(combinator_condition =~ node))

    node.attributes = { 'class' => 'foo', 'name' => 'bar' }
    assert(!(combinator_condition =~ node))
  end
end
