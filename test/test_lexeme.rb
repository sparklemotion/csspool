require File.dirname(__FILE__) + "/helper"

class LexemeTest < Test::Unit::TestCase
  include CSS
  #include CSS::SAC # grrr annoying: SAC should be a module
  
  def test_lexemes_have_a_required_name
    assert_equal(:foo, SAC::Lexeme.new(:foo, /foo/).name)
    assert_raise(ArgumentError) { SAC::Lexeme.new(nil, /foo/) }
  end
  
  def test_lexemes_require_at_least_one_pattern
    assert_raise(ArgumentError) { SAC::Lexeme.new(:foo) }
  end
  
  def test_simple_lexemes_can_specify_a_pattern_inline
    lexeme = SAC::Lexeme.new(:foo, /bar/)
    assert(lexeme.pattern.match("bar"))
  end
  
  def test_more_patterns_can_be_added_in_a_block
    lexeme = SAC::Lexeme.new(:foo) do |patterns| 
      patterns << /foo/
      patterns << /bar/
      patterns << /baz/
    end
    
    # ...but the single exposed lexeme pattern is a union
    %w(foo bar baz).each do |candidate|
      assert_match(lexeme.pattern, candidate)
    end
  end
  
  def test_patterns_are_start_anchored_and_case_insensitive
    lexeme = SAC::Lexeme.new(:foo, /foo/) 
    assert_match(lexeme.pattern, "FOO")
    assert_no_match(lexeme.pattern, " foo")
  end
end
