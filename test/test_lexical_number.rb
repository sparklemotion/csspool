require File.dirname(__FILE__) + "/helper"

class LexicalUnitTest < Test::Unit::TestCase
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

  def test_equals2_type
    first = CSS::SAC::Number.new(10, '', :SAC_INTEGER)
    second = CSS::SAC::Number.new(10, '', :SAC_INTEGER)
    assert_equal first, second

    third = CSS::SAC::Number.new(11, '', :SAC_INTEGER)
    assert_not_equal first, third
  end
end
