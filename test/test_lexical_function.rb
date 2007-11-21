require File.dirname(__FILE__) + "/helper"

class LexicalFunctionTest < Test::Unit::TestCase
  include CSS::SAC

  def test_equals2
    first = Function.new('counter(', %w{ 1 2 3 4 })
    second = Function.new('counter(', %w{ 1 2 3 4 })
    assert_equal(first, second)

    third = Function.new('rect(', %w{ 1 2 3 4 })
    assert_not_equal(first, third)

    fourth = Function.new('counter(', %w{ 1 2 3 5 })
    assert_not_equal(first, fourth)
  end
end
