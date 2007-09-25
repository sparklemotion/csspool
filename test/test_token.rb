require 'rubygems'
require 'test/unit'

require "css/sac/token"

class TokenTest < Test::Unit::TestCase
  include CSS
  #include CSS::SAC # grrr annoying: SAC should be a module

  def test_tokens_have_a_name_value_and_position
    token = SAC::Token.new(:foo, "bar", 14)
    assert_equal(:foo, token.name)
    assert_equal("bar", token.value)
    assert_equal(14, token.position)
  end
  
  def test_to_racc_token_returns_a_name_value_array
    assert_equal([:foo, "bar"], SAC::Token.new(:foo, "bar", 99).to_racc_token)
  end
  
  def test_delimiter_token_is_always_delim
    assert_equal(:delim, SAC::DelimiterToken.new(";", 99).name)
  end
  
  def test_delimiter_token_just_returns_values_for_racc
    assert_equal(%w(; ;), SAC::DelimiterToken.new(";", 99).to_racc_token)
  end
end
