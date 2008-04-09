require File.dirname(__FILE__) + "/helper"

class TokenizerTest < Test::Unit::TestCase
  include CSS::SAC
  
  def setup
    @tokenizer = Tokenizer.new
  end
  
  def test_tokenize
    assert_equal([], @tokenizer.tokenize(""))
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
    tokens = @tokenizer.tokenize('@import "subs.css" print;')
    assert_equal(6, tokens.length)
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
    tokens = @tokenizer.tokenize('@page print { color: black; }')
    assert_equal(12, tokens.length)
  
    tokens = @tokenizer.tokenize('@page :left { color: black; }')
    assert_equal(13, tokens.length)
  
    tokens = @tokenizer.tokenize('@page print :left { color: black; }')
    assert_equal(15, tokens.length)
  end
  
  def test_two_strings
    tokens = @tokenizer.tokenize('"one" "two"')
    assert_equal(3, tokens.length)
  end

  def test_at_font_face
    tokens = @tokenizer.tokenize('@font-face { color: black; }')
    assert_equal(11, tokens.length)
  end
  
  def test_ignorable_at
    tokens = @tokenizer.tokenize('@aaron { color: black; }')
    assert_equal(11, tokens.length)
  end
  
  def test_function_token
    assert_tokens("foo(aaron)", :FUNCTION, :IDENT, :delim)
  end

  def test_an_example_of_assert_tokens
    assert_tokens("body { color: pink; }",
      :IDENT, :LBRACE, :IDENT, :delim, [:IDENT, "pink"], :delim, :delim)
  end
  
  def test_comment_with_an_asterisk_in_it
    assert_tokens("/* * */", :COMMENT)
  end
  
  def assert_tokens(text, *expected)
    tokens = @tokenizer.tokenize(text).reject { |t| t.name == :S }
    
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
