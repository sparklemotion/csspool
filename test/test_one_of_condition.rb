require File.dirname(__FILE__) + "/helper"

class OneOfConditionTest < ConditionTestCase
  def test_equals_tilde
    attribute = OneOfCondition.new('class', 'foo')
    node = Node.new('p')
    node.attributes = { 'class' => 'aaron foo' }

    assert attribute =~ node

    node.attributes = { 'class' => 'bar' }
    assert(!(attribute =~ node))
    assert(!(attribute =~ 1))
  end
end
