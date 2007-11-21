require File.dirname(__FILE__) + "/helper"

class LexicalIdentTest < Test::Unit::TestCase
  include CSS::SAC

  def test_equals2
    first = LexicalIdent.new('one')
    second = LexicalIdent.new('one')
    assert_equal first, second

    third = LexicalIdent.new('two')
    assert_not_equal first, third
  end
end
