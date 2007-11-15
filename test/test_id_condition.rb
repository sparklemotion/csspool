require File.dirname(__FILE__) + "/helper"

class IdConditionTest < ConditionTestCase
  def test_equals_tilde
    attribute = IDCondition.new('some_id')
    node = Node.new('p')
    node.attributes = { 'id' => 'some_id' }

    assert attribute =~ node

    node.attributes = { 'id' => 'different' }
    assert(!(attribute =~ node))
    assert(!(attribute =~ 1))
  end
end

