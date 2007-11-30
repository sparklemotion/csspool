require File.dirname(__FILE__) + "/helper"

class ErrorRecoveryTest < Test::Unit::TestCase
  def setup
    @sac = CSS::SAC::Parser.new
  end

  def test_unexpected_color
    doc = @sac.parse('
      a { color: red; }
      body { border: solid 1px; #000; color: red; }
      p { color: blue; }
    ')
    assert_equal 3, doc.rules.length

    a_rule = doc['a']
    assert a_rule
    assert_equal 1, a_rule.properties.length

    body_rule = doc['body']
    assert body_rule
    assert_equal 2, body_rule.properties.length

    p_rule = doc['p']
    assert p_rule
    assert_equal 1, p_rule.properties.length
  end
end
