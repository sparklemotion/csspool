class ParseErrorTest < Test::Unit::TestCase
  def setup
    @sac = CSS::SAC::Parser.new()
  end

  def test_unknown_properties
    flexmock(@sac.document_handler).
      should_receive(:start_document).ordered.once
    flexmock(@sac.document_handler).
      should_receive(:property).ordered.with('color', on { |list|
      list.length == 1 && list.first.dimension_unit_text.nil? &&
        list.first.lexical_unit_type == :SAC_IDENT &&
        list.first.string_value == "red" &&
        list.first.integer_value.nil?
    }, false).once
    flexmock(@sac.error_handler).
      should_receive(:error).ordered.once
    flexmock(@sac.document_handler).
      should_receive(:property).ordered.with('color', on { |list|
      list.length == 1 && list.first.dimension_unit_text.nil? &&
        list.first.lexical_unit_type == :SAC_IDENT &&
        list.first.string_value == "red" &&
        list.first.integer_value.nil?
    }, false).once
    flexmock(@sac.document_handler).
      should_receive(:end_document).ordered.once
    @sac.parse('h1 { color: red; rotation: 70minutes } h2 { color: red }')
    flexmock_verify
  end
end
