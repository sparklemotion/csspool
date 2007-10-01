class LexicalUnitTest < Test::Unit::TestCase
  def setup
    @sac = CSS::SAC::Parser.new()
  end

  def test_mm
    flexmock(@sac.document_handler).
      should_receive(:property).with('height', on { |list|
      list.length == 1 && list.first.dimension_unit_text == 'mm' &&
        list.first.lexical_unit_type == :SAC_MILLIMETER &&
        list.first.integer_value == 1
    }, false).once

    @sac.parse('h1 { height: 1mm; }')
    flexmock_verify
  end
end
