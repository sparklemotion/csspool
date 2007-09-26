require 'rubygems'
require 'test/unit'
require 'flexmock/test_unit'
require 'css/sac'

class ParserTest < Test::Unit::TestCase
  def setup
    @sac = CSS::SAC::Parser.new()
  end

  def test_page
    flexmock(@sac.document_handler).
      should_receive(:start_page).ordered.
        with('foo', 'print').once
    flexmock(@sac.document_handler).
      should_receive(:property).ordered.
      with('color', ['black'], false).once
    flexmock(@sac.document_handler).
      should_receive(:end_page).ordered.
        with('foo', 'print').once
    @sac.parse('@page foo:print { color: black }')
  end

  def test_empty
    assert_nothing_raised {
      @sac.parse('')
    }
  end

  def test_media
    flexmock(@sac.document_handler).
      should_receive(:start_media).ordered.
        with(['print', 'tv']).once
    flexmock(@sac.document_handler).
      should_receive(:start_selector).ordered.
      with(['h1']).once
    flexmock(@sac.document_handler).
      should_receive(:property).ordered.
      with('color', ['black'], false).once
    flexmock(@sac.document_handler).
      should_receive(:end_selector).ordered.
      with(['h1']).once
    flexmock(@sac.document_handler).
      should_receive(:end_media).ordered.
        with(['print', 'tv']).once
    @sac.parse('@media print, tv { h1 { color: black } }')
  end

  def test_media_single
    flexmock(@sac.document_handler).
      should_receive(:start_media).ordered.
        with(['print']).once
    flexmock(@sac.document_handler).
      should_receive(:end_media).ordered.
        with(['print']).once
    @sac.parse('@media print { h1 { color: black } }')
  end

  def test_comment
    flexmock(@sac.document_handler).
      should_receive(:comment).ordered.
      with("/* sup bro */").once
    @sac.parse('/* sup bro */')
  end

  def test_ignorable_at_rule
    flexmock(@sac.document_handler).
      should_receive(:start_document).ordered.once
    flexmock(@sac.document_handler).
      should_receive(:ignorable_at_rule).ordered.
      with("blah").once
    flexmock(@sac.document_handler).
      should_receive(:end_document).ordered.once
    @sac.parse('@blah "style.css";')
  end

  def test_selector
    flexmock(@sac.document_handler).
      should_receive(:start_document).ordered.once
    flexmock(@sac.document_handler).
      should_receive(:start_selector).ordered.
      with(['div', 'h1']).once
    flexmock(@sac.document_handler).
      should_receive(:property).ordered.
      with('color', ['black'], false).once
    flexmock(@sac.document_handler).
      should_receive(:end_selector).ordered.
      with(['div', 'h1']).once
    flexmock(@sac.document_handler).
      should_receive(:end_document).ordered.once

    @sac.parse('div h1 { color: black; }')
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
    @sac.parse('h1 { color: black !important; }')
    flexmock_verify
  end
end
