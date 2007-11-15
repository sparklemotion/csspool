require File.dirname(__FILE__) + "/helper"

class ClassConditionTest < ConditionTestCase
  def test_tilde_equals
    attribute = ClassCondition.new('foo')
    node = Node.new('p')
    node.attributes = { 'class' => 'foo' }

    assert attribute =~ node

    node.attributes = { 'class' => 'barfoo' }
    assert(!(attribute =~ node))
    assert(!(attribute =~ 1))
  end
end
