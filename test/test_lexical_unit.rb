require 'test/unit'
require 'rubygems'
require 'test/unit'
require 'flexmock/test_unit'
require 'flexmock/argument_types'
require 'css/sac'

class LexicalUnitTest < Test::Unit::TestCase
  def setup
    @sac = CSS::SAC::Parser.new()
  end

  def test_color
    flexmock(@sac.document_handler).
      should_receive(:property).with('background-color', on { |list|
      list.length == 1 && list.first.dimension_unit_text.nil? &&
        list.first.lexical_unit_type == :SAC_RGBCOLOR &&
        list.first.string_value == "#345" &&
        list.first.parameters.length == 3 &&
        list.first.parameters.map { |x| x.integer_value } == [3,4,5] &&
        list.first.integer_value.nil?
    }, false).once

    @sac.parse('h1 { background-color: #345; }')
    flexmock_verify
  end

  def test_color_6
    flexmock(@sac.document_handler).
      should_receive(:property).with('background-color', on { |list|
      list.length == 1 && list.first.dimension_unit_text.nil? &&
        list.first.lexical_unit_type == :SAC_RGBCOLOR &&
        list.first.string_value == "#330405" &&
        list.first.parameters.length == 3 &&
        list.first.parameters.map { |x| x.integer_value } == [51,4,5] &&
        list.first.integer_value.nil?
    }, false).once

    @sac.parse('h1 { background-color: #330405; }')
    flexmock_verify
  end

  def test_uri
    flexmock(@sac.document_handler).
      should_receive(:property).with('content', on { |list|
      list.length == 1 && list.first.dimension_unit_text.nil? &&
        list.first.lexical_unit_type == :SAC_URI &&
        list.first.string_value == "\"aaron\"" &&
        list.first.integer_value.nil?
    }, false).once

    @sac.parse('h1 { content: url("aaron"); }')
    flexmock_verify
  end

  def test_string
    flexmock(@sac.document_handler).
      should_receive(:property).with('content', on { |list|
      list.length == 1 && list.first.dimension_unit_text.nil? &&
        list.first.lexical_unit_type == :SAC_STRING_VALUE &&
        list.first.string_value == "\"aaron\"" &&
        list.first.integer_value.nil?
    }, false).once

    @sac.parse('h1 { content: "aaron"; }')
    flexmock_verify
  end

  def test_ident
    flexmock(@sac.document_handler).
      should_receive(:property).with('color', on { |list|
      list.length == 1 && list.first.dimension_unit_text.nil? &&
        list.first.lexical_unit_type == :SAC_IDENT &&
        list.first.string_value == "black" &&
        list.first.integer_value.nil?
    }, false).once

    @sac.parse('h1 { color: black; }')
    flexmock_verify
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
