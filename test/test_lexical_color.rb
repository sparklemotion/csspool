require File.dirname(__FILE__) + "/helper"

class LexicalColorTest < Test::Unit::TestCase
  include CSS::SAC

  def test_to_s
    first = Color.new('#FFFFFF')
    assert_equal('#FFF', first.to_s)

    second = Color.new('#FEFEFE')
    assert_equal('#FEFEFE', second.to_s)

    third = Color.new('red')
    assert_equal('red', third.to_s)

    fourth = Color.new('#0066FF')
    assert_equal('#06F', fourth.to_s)
  end

  def test_hash
    first = Color.new('#FFFFFF')
    second = Color.new('#FFFFFF')
    assert_equal first.hash, second.hash

    third = Color.new('red')
    assert_not_equal first.hash, third.hash
  end

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
