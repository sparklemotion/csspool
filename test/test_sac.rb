require 'rubygems'
require 'test/unit'
require 'flexmock/test_unit'
require 'css/sac'

class SACParserTest < Test::Unit::TestCase
  def setup
    @sac = CSS::SAC.new()
  end
  
  def test_parse_simple
    @sac.parse('
      @import "subs.css";
      * {  margin: 0px; }
      body {
        margin: 0px;
        padding: 0px;
      }
    ')

    assert_equal(39, @sac.tokens.length)
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

  def test_selector
    flexmock(@sac.document_handler).
      should_receive(:start_selector).
      with(['div', 'h1']).once
    flexmock(@sac.document_handler).
      should_receive(:end_selector).
      with(['div', 'h1']).once

    @sac.parse('div h1 { color: black; }')
    assert_equal(13, @sac.tokens.length)
    flexmock_verify
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
    
    tokens.zip(expected).each do |sets|
      token, expected_name, expected_value = sets.flatten
      assert_equal(expected_name, token.name, "token #{count} name")
      assert_equal(expected_value, token.value, "token #{count} value") if expected_value
      count += 1
    end
  end
end
