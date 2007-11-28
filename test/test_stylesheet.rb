require File.dirname(__FILE__) + "/helper"

class StyleSheetTest < SelectorTestCase
  def setup
    @sac = CSS::SAC::Parser.new
  end

  def test_rules_matching
    doc = @sac.parse("div > p { letter-spacing: 1px; }")
    node = parent_child_tree('div', 'p')
    expected = doc.rules.first

    found = doc.rules_matching(node)
    assert_equal 1, found.length
    assert_equal expected.selector, found.first.selector

    found2 = (doc =~ node)
    assert_equal 1, found2.length
    assert_equal expected.selector, found2.first.selector
  end

  def test_find_rule
    doc = @sac.parse("h1 { letter-spacing: 1px; }")
    expected = doc.rules.first
    assert_equal expected, doc.find_rule('h1')
    assert_equal expected, doc['h1']
    assert_equal expected, doc[expected]
  end

  def test_create_rule
    doc = @sac.parse("h1 { letter-spacing: 1px; }")
    rule = doc.create_rule('h1')
    assert_equal doc.rules.first.selector, rule.selector
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
    assert_equal(1, doc.rules.length)
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

  def test_to_css
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
  .marquee { background: url(images/sfx1_bg.gif) bottom repeat-x;}
  SELECT {font-family: Arial, Verdana, Geneva, sans-serif; font-size: small; }
END
    )
    css = doc.to_css
    assert_match('div, h1 {', css)

    [ 'border-color:green;',
      'background-color:red;',
      'url(images/sfx1_bg.gif',
      'Arial, Verdana, Geneva, sans-serif;',
      'padding:100px;'].each do |attribute|
      assert_match(attribute, css)
    end
  end
end
