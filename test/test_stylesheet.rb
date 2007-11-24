require File.dirname(__FILE__) + "/helper"

class StyleSheetTest < ConditionTestCase
  def setup
    @sac = CSS::SAC::Parser.new(CSS::StyleSheet.new())
  end

  def test_reduce!
    doc = @sac.parse(<<END
  h1 {
    background-color: red;
    border-color: green;
  }
  h1 { letter-spacing: 1px; }
END
    )
    assert_equal(2, doc.rules.length)

    doc.reduce!
    assert_equal(1, doc.rules.length)
    assert_equal(3, doc.rules.first.properties.length)
  end

  def test_rules_by_property
    doc = @sac.parse(<<END
  h1 {
    background-color: red;
    padding: 100px;
    border-color: green;
  }
  div {
    border-color: green;
    background-color: red;
    padding: 100px;
  }
END
    )
    assert_equal(2, doc.rules.length)
    assert_equal(doc.rules[0].properties, doc.rules[1].properties)
    assert_equal(1, doc.rules_by_property.keys.length)
    assert_equal(2, doc.rules_by_property.values.first.length)
  end
end
