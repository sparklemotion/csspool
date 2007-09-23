require 'rubygems'
require 'test/unit'
require 'flexmock/test_unit'
require 'css/sac'

class ParserTest < Test::Unit::TestCase
  def setup
    @sac = CSS::SAC.new()
  end

  def test_selector
    flexmock(@sac.document_handler).
      should_receive(:start_selector).
      with(['div', 'h1']).once
    flexmock(@sac.document_handler).
      should_receive(:end_selector).
      with(['div', 'h1']).once

    @sac.parse('div h1 { color: black; }')
    #p @sac.tokens.map { |x| x.value }
    assert_equal(13, @sac.tokens.length)
    flexmock_verify
  end

  def test_properties
    flexmock(@sac.document_handler).
      should_receive(:property).
      with('color', ['black'], false).once
    @sac.parse('div h1 { color: black; }')
    flexmock_verify

    flexmock(@sac.document_handler).
      should_receive(:property).never
    @sac.parse('div h1 { }')
    flexmock_verify
  end

  def test_important_properties
    flexmock(@sac.document_handler).
      should_receive(:property).
      with('color', ['black'], true).once
    @sac.parse('div h1 { color: black !important; }')
    flexmock_verify
  end
end
