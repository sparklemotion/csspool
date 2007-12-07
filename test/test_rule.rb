require File.dirname(__FILE__) + "/helper"

class RuleTest < SelectorTestCase
  def setup
    @sac = CSS::SAC::Parser.new
  end

  def test_spaceship
    doc = @sac.parse("div > p { letter-spacing: 1px; } #foo { color: red }")

    rule1 = doc['div > p']
    rule2 = doc['#foo']

    assert_not_nil rule1
    assert_not_nil rule2

    assert rule2 > rule1
    assert rule1 < rule2
  end

  def test_equal_spec_goes_by_index
    doc = @sac.parse("h1 { letter-spacing: 1px; } h2 { color: red }")
    rule1 = doc['h1']
    rule2 = doc['h2']

    assert_not_nil rule1
    assert_not_nil rule2
    assert_equal rule1.selector.specificity, rule2.selector.specificity

    assert rule2 > rule1
    assert rule1 < rule2
  end
end
