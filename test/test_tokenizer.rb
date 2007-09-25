require 'rubygems'
require 'test/unit'

require 'css/sac'

# NOTE: these aren't valid tests!

class TokenizerTest < Test::Unit::TestCase
  def setup
    @sac = CSS::SAC::Parser.new()
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
      [:IMPORT_SYM, "@import"],
      [:STRING, "\"subs.css\""],
      [:delim, ";"],
      [:delim, "*"],
      [:LBRACE, " {"],
      [:IDENT, "margin"],
      [:delim, ":"],
      [:LENGTH, "0px"],
      [:delim, ";"],
      [:delim, "}"],
      [:IDENT, "body"],
      [:LBRACE, " {"],
      [:IDENT, "margin"],
      [:delim, ":"],
      [:LENGTH, "0px"],
      [:delim, ";"],
      [:IDENT, "padding"],
      [:delim, ":"],
      [:LENGTH, "0px"],
      [:delim, ";"],
      [:delim, "}"])
  end

  def test_at_import
    @sac.parse('@import "subs.css" print;')
    assert_equal(6, @sac.tokens.length)
  end

  def test_at_media
    assert_tokens('@media print { h1 { color: black; } }',
      [:MEDIA_SYM, "@media"],
      [:IDENT, "print"],
      [:LBRACE, " {"],
      [:IDENT, "h1"],
      [:LBRACE, " {"],
      [:IDENT, "color"],
      [:delim, ":"],
      [:IDENT, "black"],
      [:delim, ";"],
      [:delim, "}"],
      [:delim, "}"])
  end

  def test_at_page
    @sac.parse('@page print { color: black; }')
    assert_equal(12, @sac.tokens.length)

    @sac.parse('@page :left { color: black; }')
    assert_equal(13, @sac.tokens.length)

    @sac.parse('@page print :left { color: black; }')
    assert_equal(15, @sac.tokens.length)
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
      :IDENT, :LBRACE, :IDENT, :delim, [:IDENT, "pink"], :delim, :delim)
  end
  
  def assert_tokens(text, *expected)
    parser = CSS::SAC.parse(text)
    
    tokens = parser.tokens.reject { |t| t.name == :S }
    #puts tokens.collect { |t| [t.name, t.value].inspect }.join(",\n")
    
    assert_equal(expected.size, tokens.size)
    
    count = 1
        
    tokens.zip(expected).each do |sets|
      token, expected_name, expected_value = sets.flatten
      assert_equal(expected_name, token.name, "token #{count} name")
      assert_equal(expected_value, token.value, "token #{count} value") if expected_value
      count += 1
    end
  end
end
