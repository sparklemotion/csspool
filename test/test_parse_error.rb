require File.dirname(__FILE__) + "/helper"

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
        list.first.string_value == "black" &&
        list.first.integer_value.nil?
    }, false).once
    flexmock(@sac.document_handler).
      should_receive(:end_document).ordered.once
    @sac.parse('h1 { color: red; rotation: 70minutes; } h2 { color: black }')
    flexmock_verify
  end

  def test_error_media
    flexmock(@sac.document_handler).
      should_receive(:start_media).ordered.
      with(['all']).once
    flexmock(@sac.error_handler).
      should_receive(:error).ordered.once
    flexmock(@sac.document_handler).
      should_receive(:end_media).ordered
    @sac.parse('@media all and (min-width:0px) { }')
    flexmock_verify
  end

  def test_bad_selector
    flexmock(@sac.document_handler).
      should_receive(:start_selector).ordered.once
    flexmock(@sac.document_handler).
      should_receive(:property).ordered.with('height', any, false).once
    flexmock(@sac.document_handler).
      should_receive(:end_selector).ordered.once

    @sac.parse('head~body div#user-section { height: 0; }')
    flexmock_verify
  end

  def test_malformed_decl_missing_value
    flexmock(@sac.document_handler).
      should_receive(:property).ordered.with('color', on { |list|
      list.length == 1 && list.first.dimension_unit_text.nil? &&
        list.first.lexical_unit_type == :SAC_IDENT &&
        list.first.string_value == "green" &&
        list.first.integer_value.nil?
    }, false).once
    @sac.parse('p { color:green; color }')
    flexmock_verify
  end

  def test_function_recover
    flexmock(@sac.document_handler).
      should_receive(:property).ordered.with('color', on { |list|
      list.length == 1 && list.first.dimension_unit_text.nil? &&
        list.first.lexical_unit_type == :SAC_IDENT &&
        list.first.string_value == "red" &&
        list.first.integer_value.nil?
    }, false).once
    @sac.parse('#modal_cover { filter: alpha(opacity=75); color: red; }')
    flexmock_verify
  end

  def test_malformed_decl_missing_value_recovery
    flexmock(@sac.document_handler).
      should_receive(:property).ordered.with('color', on { |list|
      list.length == 1 && list.first.dimension_unit_text.nil? &&
        list.first.lexical_unit_type == :SAC_IDENT &&
        list.first.string_value == "red" &&
        list.first.integer_value.nil?
    }, false).once
    flexmock(@sac.document_handler).
      should_receive(:property).ordered.with('color', on { |list|
      list.length == 1 && list.first.dimension_unit_text.nil? &&
        list.first.lexical_unit_type == :SAC_IDENT &&
        list.first.string_value == "green" &&
        list.first.integer_value.nil?
    }, false).once
    @sac.parse('p { color:red; color; color:green }')
    flexmock_verify
  end

  def test_malformed_decl_missing_value_with_colon
    flexmock(@sac.document_handler).
      should_receive(:property).ordered.with('color', on { |list|
      list.length == 1 && list.first.dimension_unit_text.nil? &&
        list.first.lexical_unit_type == :SAC_IDENT &&
        list.first.string_value == "green" &&
        list.first.integer_value.nil?
    }, false).once
    @sac.parse('p { color:green; color: }')
    flexmock_verify
  end

  def test_malformed_decl_missing_value_recovery_with_colon
    flexmock(@sac.document_handler).
      should_receive(:property).ordered.with('color', on { |list|
      list.length == 1 && list.first.dimension_unit_text.nil? &&
        list.first.lexical_unit_type == :SAC_IDENT &&
        list.first.string_value == "red" &&
        list.first.integer_value.nil?
    }, false).once
    flexmock(@sac.document_handler).
      should_receive(:property).ordered.with('color', on { |list|
      list.length == 1 && list.first.dimension_unit_text.nil? &&
        list.first.lexical_unit_type == :SAC_IDENT &&
        list.first.string_value == "green" &&
        list.first.integer_value.nil?
    }, false).once
    @sac.parse('p { color:red; color:; color:green }')
    flexmock_verify
  end

  def test_malformed_decl_missing_value_unexpected_tokens
    flexmock(@sac.document_handler).
      should_receive(:property).ordered.with('color', on { |list|
      list.length == 1 && list.first.dimension_unit_text.nil? &&
        list.first.lexical_unit_type == :SAC_IDENT &&
        list.first.string_value == "green" &&
        list.first.integer_value.nil?
    }, false).once
    @sac.parse('p { color:green; color{;color:maroon} }')
    flexmock_verify
  end

  def test_malformed_decl_missing_value_unexpected_tokens_recover
    flexmock(@sac.document_handler).
      should_receive(:property).ordered.with('color', on { |list|
      list.length == 1 && list.first.dimension_unit_text.nil? &&
        list.first.lexical_unit_type == :SAC_IDENT &&
        list.first.string_value == "red" &&
        list.first.integer_value.nil?
    }, false).once
    flexmock(@sac.document_handler).
      should_receive(:property).ordered.with('color', on { |list|
      list.length == 1 && list.first.dimension_unit_text.nil? &&
        list.first.lexical_unit_type == :SAC_IDENT &&
        list.first.string_value == "green" &&
        list.first.integer_value.nil?
    }, false).once
    @sac.parse('p { color:red;   color{;color:maroon}; color:green }')
    flexmock_verify
  end

  def test_invalid_at_keyword
    flexmock(@sac.document_handler).
      should_receive(:property).ordered.with('color', on { |list|
      list.length == 1 && list.first.dimension_unit_text.nil? &&
        list.first.lexical_unit_type == :SAC_IDENT &&
        list.first.string_value == "blue" &&
        list.first.integer_value.nil?
    }, false).once
    @sac.parse(
    '@three-dee {
      @background-lighting {
        azimuth: 30deg;
        elevation: 190deg;
      }
      h1 { color: red }
    }
    h1 { color: blue }')
  end

  def test_extra_semi
    flexmock(@sac.document_handler).
      should_receive(:property).ordered.with('color', on { |list|
      list.length == 1 && list.first.dimension_unit_text.nil? &&
        list.first.lexical_unit_type == :SAC_IDENT &&
        list.first.string_value == "red" &&
        list.first.integer_value.nil?
    }, false).once
    flexmock(@sac.document_handler).
      should_receive(:property).ordered.with('color', on { |list|
      list.length == 1 && list.first.dimension_unit_text.nil? &&
        list.first.lexical_unit_type == :SAC_IDENT &&
        list.first.string_value == "green" &&
        list.first.integer_value.nil?
    }, false).once
    @sac.parse('p { color:red;  ; color:green }')
    flexmock_verify
  end
end
