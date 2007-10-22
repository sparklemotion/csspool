require 'rubygems'
require 'test/unit'
require 'css/sac/parser'

class SelectorParserTest < Test::Unit::TestCase
  def setup
    @sac = CSS::SAC::Parser.new()
  end

  def test_universal
    @sac.parse('* { }')
  end

  def test_attribute
    @sac.parse('h1[foo="warning"] { }')
  end
end
