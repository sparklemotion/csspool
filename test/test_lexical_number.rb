require File.dirname(__FILE__) + "/helper"

class LexicalNumberTest < Test::Unit::TestCase
  def test_hash
    first = CSS::SAC::Number.new('10', 'px')
    second = CSS::SAC::Number.new('10', 'px')
    assert_equal first.hash, second.hash

    third = CSS::SAC::Number.new('11', 'px')
    assert_not_equal first.hash, third.hash

    fourth = CSS::SAC::Number.new('10', 'em')
    assert_not_equal first.hash, fourth.hash
  end

  def test_hash_0_unit
    first = CSS::SAC::Number.new('0', 'px')
    second = CSS::SAC::Number.new('0', 'px')
    assert_equal first.hash, second.hash

    third = CSS::SAC::Number.new('0', 'em')
    assert_equal first.hash, third.hash
  end

  def test_equals2
    first = CSS::SAC::Number.new('10', 'px')
    second = CSS::SAC::Number.new('10', 'px')
    assert_equal first, second

    third = CSS::SAC::Number.new('10', 'ex')
    assert_not_equal first, third

    fourth = CSS::SAC::Number.new('11', 'px')
    assert_equal(11, fourth.integer_value)
    assert_not_equal first, fourth
  end

  def test_equals2_zero
    first = CSS::SAC::Number.new('0', 'px')
    second = CSS::SAC::Number.new('0', 'em')
    assert_equal first, second

    first_float = CSS::SAC::Number.new('0.0', 'px')
    second_float = CSS::SAC::Number.new('0.0', 'em')
    assert_equal first_float, second_float

    third_float = CSS::SAC::Number.new('0.1', 'em')
    assert_equal 0.1, third_float.float_value
    assert_not_equal first_float, third_float
  end

  def test_equals2_type
    first = CSS::SAC::Number.new(10, '', :SAC_INTEGER)
    second = CSS::SAC::Number.new(10, '', :SAC_INTEGER)
    assert_equal first, second

    third = CSS::SAC::Number.new(11, '', :SAC_INTEGER)
    assert_not_equal first, third
  end
end
