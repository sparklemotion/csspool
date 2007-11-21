require File.dirname(__FILE__) + "/helper"

class LexicalColorTest < Test::Unit::TestCase
  include CSS::SAC

  def test_equals2
    first = Color.new('#FFFFFF')
    second = Color.new('#FFFFFF')
    assert_equal(first, second)

    third = Color.new('#FFF')
    assert_equal(first, third)

    fourth = Color.new('#FFA')
    assert_not_equal(first, fourth)
  end

  def test_equals2_string
    first = Color.new('red')
    second = Color.new('red')
    assert_equal(first, second)

    third = Color.new('#FFF')
    assert_not_equal(first, third)
  end
end
