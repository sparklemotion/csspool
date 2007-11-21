require File.dirname(__FILE__) + "/helper"

class LexicalStringTest < Test::Unit::TestCase
  include CSS::SAC

  def test_equals2
    first = LexicalString.new('hey bro')
    second = LexicalString.new('hey bro')
    assert_equal(first, second)

    third = LexicalString.new('hey bro again')
    assert_not_equal(first, third)
  end
end
