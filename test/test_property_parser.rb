require 'rubygems'
require 'test/unit'
require 'css/sac/parser'

class PropertyParserTest < Test::Unit::TestCase
  def setup
    @tokenizer = CSS::SAC::Tokenizer.new()
    @property_parser = CSS::SAC::PropertyParser.new()
  end

  def test_error
    tokens = @tokenizer.tokenize("h1 { azimuth: blahblah; }").find_all { |x|
      ![:LBRACE, :S].include?(x.name) &&
        !['h1', '}', ':', ';'].include?(x.value)
    }
    assert_nil(@property_parser.parse_tokens(tokens))
  end

  @@valid_value_tests = {
    :azimuth  =>  [ '10deg', 'left-side', 'far-left', 'left', 'center-left',
                    'right', 'far-right', 'right-side', 'behind', 'left behind',
                    'leftwards', 'rightwards', 'inherit'
                  ],
    'background-attachment' => [ 'scroll', 'fixed', 'inherit' ],
    'background-color'  => ['red', '#FFFFFF', 'transparent', 'inherit'],
    'background-image' => [ 'url("http://example.com/test.png")', 'none',
                            'inherit'],
    'background-position' =>  [ '10%', '10px', 'left', 'center', 'right',
                                '10% 10%', '10% top', 'left center',
                                'center left', 'inherit'],
    'background-repeat' => ['repeat', 'repeat-x', 'repeat-y', 'no-repeat',
                            'inherit'],
    'background'  => ['red', 'url("http://example.com/test.png")', 'repeat',
                      'scroll', 'left', 'red repeat', 'repeat red'],
    'border-collapse' => ['collapse', 'separate', 'inherit'],
    'border-color'  => ['black', '#aaa', 'black red blue green', 'black red',
                        'black red #aaa', 'inherit'],
    'border-spacing'  => ['0.5em', '10px 0.5em', 'inherit'],
    'border-style'    => ['none', 'hidden dotted', 'dashed solid groove',
                          'outset inset ridge double'],
    [ 'border-top',
      'border-right',
      'border-bottom',
      'border-left' ] => ['thin', 'red', 'hidden', '10px dashed',
                          'medium red dashed', 'inherit'],
    [ 'border-top-color',
      'border-right-color',
      'border-bottom-color',
      'border-left-color' ] => ['#fff', 'green', 'transparent', 'inherit'],
    [ 'border-top-style',
      'border-right-style',
      'border-bottom-style',
      'border-left-style' ] => ['none', 'dotted', 'dashed', 'inherit'],
    [ 'border-top-width',
      'border-right-width',
      'border-bottom-width',
      'border-left-width' ] => ['thin', 'medium', 'thick', '10px', 'inherit'],
    'border-width' => ['thin', 'medium thin', 'thin medium 10px',
                        'thin thick 10px medium', 'inherit' ],
  }

  @@valid_value_tests.each do |k,v|
    [k].flatten.each do |key|
      define_method :"test_valid_#{key.to_s.gsub(/-/, '_')}" do
        v.each do |value|
          tok = @tokenizer.tokenize("h1 { #{key}: #{value}; }").find_all { |x|
            ![:LBRACE, :S].include?(x.name) &&
              !['h1', '}', ':', ';'].include?(x.value)
          }
          result = @property_parser.parse_tokens(tok)
          if result.nil?
            p tok
          end
          assert(result)
        end
      end
    end
  end
end
