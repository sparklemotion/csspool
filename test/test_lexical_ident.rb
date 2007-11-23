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

  def test_eql?
    first = LexicalIdent.new('one')
    second = LexicalIdent.new('one')

    assert first.eql?(second)
  end

  def test_hash
    first = LexicalIdent.new('one')
    second = LexicalIdent.new('one')
    assert_equal first.hash, second.hash

    third = LexicalIdent.new('two')
    assert_not_equal first.hash, third.hash
  end
end
