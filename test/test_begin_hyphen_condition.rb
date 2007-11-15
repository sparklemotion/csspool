require File.dirname(__FILE__) + "/helper"

class BeginHyphenConditionTest < ConditionTestCase
  def test_tilde_equals
    attribute = BeginHyphenCondition.new('class', 'foo')
    node = Node.new('p')
    node.attributes = { 'class' => 'foobar' }

    assert attribute =~ node

    node.attributes = { 'class' => 'barfoo' }
    assert(!(attribute =~ node))
    assert(!(attribute =~ 1))
  end
end
