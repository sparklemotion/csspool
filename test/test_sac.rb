require 'rubygems'
require 'test/unit'
require 'css/sac'

class TokenizerTest < Test::Unit::TestCase
  def setup
    @sac = CSS::SAC.new()
  end
  
  def test_parse_simple
    text = '
      @import "subs.css";
      * {  margin: 0px; }
      body {
        margin: 0px;
        padding: 0px;
      }'
    
    assert_tokens(text,
      [:atkeyword, "@import"],
      [:string, "\"subs.css\""],
      :semi,
      [:delim, "*"],
      :l_curly,
      [:ident, "margin"],
      [:delim, ":"],
      [:number, "0"],
      [:ident, "px"],
      :semi,
      :r_curly,
      [:ident, "body"],
      :l_curly,
      [:ident, "margin"],
      [:delim, ":"],
      [:number, "0"],
      [:ident, "px"],
      :semi,
      [:ident, "padding"],
      [:delim, ":"],
      [:number, "0"],
      [:ident, "px"],
      :semi,
      :r_curly)
  end

  def test_at_import
    @sac.parse('@import "subs.css" print;')
    assert_equal(6, @sac.tokens.length)
  end

  def test_at_media
    @sac.parse('@media print { h1 { color: black; } }')
    assert_equal(19, @sac.tokens.length)
  end

  def test_at_page
    @sac.parse('@page print { color: black; }')
    assert_equal(13, @sac.tokens.length)

    @sac.parse('@page :left { color: black; }')
    assert_equal(14, @sac.tokens.length)

    @sac.parse('@page print :left { color: black; }')
    assert_equal(16, @sac.tokens.length)
  end

  def test_at_font_face
    @sac.parse('@font-face { color: black; }')
    assert_equal(11, @sac.tokens.length)
  end

  def test_ignorable_at
    @sac.parse('@aaron { color: black; }')
    assert_equal(11, @sac.tokens.length)
  end

  def test_an_example_of_assert_tokens
    assert_tokens("body { color: pink; }",
      :ident, :l_curly, :ident, :delim, [:ident, "pink"], :semi, :r_curly)
  end
  
  def assert_tokens(text, *expected)
    parser = CSS::SAC.new
    parser.parse(text)
    
    tokens = parser.tokens.reject { |t| t.name == :s }
    assert_equal(tokens.size, expected.size)
    
    count = 1
    
    # puts tokens.collect { |t| [t.name, t.value] }.inspect
    
    tokens.zip(expected).each do |sets|
      token, expected_name, expected_value = sets.flatten
      assert_equal(expected_name, token.name, "token #{count} name")
      assert_equal(expected_value, token.value, "token #{count} value") if expected_value
      count += 1
    end
  end
end
