require File.dirname(__FILE__) + "/helper"

class SimpleSelectorTest < SelectorTestCase
  def test_equals_tilde
    sel = SimpleSelector.new
    assert(! (sel =~ nil))
    assert(sel =~ Node.new)
  end
end
