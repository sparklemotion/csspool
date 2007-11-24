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
    assert_equal(2, doc.selectors.length)

    doc.reduce!
    assert_equal(1, doc.selectors.length)
    assert_equal(3, doc.selectors.first.properties.length)
  end
end
