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
    :azimuth  => {
      :values =>  [ '10deg', 'left-side', 'far-left', 'left', 'center-left',
                    'right', 'far-right', 'right-side', 'behind', 'left behind',
                    'leftwards', 'rightwards', 'inherit'
                  ],
      :unit_types => [ :SAC_DEGREE, nil, nil, nil, nil, nil, nil, nil, nil,
                      [:SAC_IDENT, :SAC_IDENT], nil, nil, nil ],
    },

    'background-attachment' => {
      :values => [ 'scroll', 'fixed', 'inherit' ],
      :unit_types => [nil, nil, nil],
    },

    'background-color'  => {
      :values => ['red', '#FFFFFF', 'transparent', 'inherit'],
      :unit_types => [nil, :SAC_RGBCOLOR, nil, nil ],
    },

    'background-image' => {
      :values => [ 'url("http://example.com/test.png")', 'none', 'inherit'],
      :unit_types => [ :SAC_URI, nil, nil ],
    },

    'background-position' => {
      :values =>  [ '10%', '10px', 'left', 'center', 'right',
                                '10% 10%', '10% top', 'left center',
                                'center left', 'inherit'],
      :unit_types => [ :SAC_PERCENTAGE, :SAC_PIXEL, nil, nil, nil,
        [:SAC_PERCENTAGE, :SAC_PERCENTAGE], [:SAC_PERCENTAGE, nil], [nil,nil],
        [nil, nil], nil ],
    },

    'background-repeat' => {
      :values => ['repeat', 'repeat-x', 'repeat-y', 'no-repeat',
                            'inherit'],
      :unit_types => [nil, nil, nil, nil, nil],
    },

    'background'  => {
      :values => ['red', 'url("http://example.com/test.png")', 'repeat',
                      'scroll', 'left', 'red repeat', 'repeat red'],
      :unit_types => [nil, :SAC_URI, nil,
        nil, nil, [nil, nil], [nil, nil]],
    },

    'border-collapse' => {
      :values => ['collapse', 'separate', 'inherit'],
      :unit_types => [nil, nil, nil],
    },

    'border-color'  => {
      :values => ['black', '#aaa', 'black red blue green', 'black red',
                        'black red #aaa', 'inherit'],
      :unit_types => [nil, :SAC_RGBCOLOR, [nil, nil, nil, nil], [nil, nil],
        [nil, nil, :SAC_RGBCOLOR], nil],
    },

    'border-spacing'  => {
      :values => ['0.5em', '10px 0.5em', 'inherit'],
      :unit_types => [:SAC_EM, [:SAC_PIXEL, :SAC_EM], nil],
    },

    'border-style'    => {
      :values => ['none', 'hidden dotted', 'dashed solid groove',
                          'outset inset ridge double'],
      :unit_types => [nil, [nil, nil], [nil, nil, nil], [nil,nil,nil,nil]],
    },

    [ 'border-top',
      'border-right',
      'border-bottom',
      'border-left' ] => {
      :values => ['thin', 'red', 'hidden', '10px dashed',
                          'medium red dashed', 'inherit'],
      :unit_types => [nil, nil, nil, [:SAC_PIXEL, nil], [nil, nil, nil], nil],
    },

    [ 'border-top-color',
      'border-right-color',
      'border-bottom-color',
      'border-left-color' ] => {
      :values => ['#fff', 'green', 'transparent', 'inherit'],
      :unit_types => [:SAC_RGBCOLOR, nil, nil, nil],
    },

    [ 'border-top-style',
      'border-right-style',
      'border-bottom-style',
      'border-left-style' ] => {
      :values => ['none', 'dotted', 'dashed', 'inherit'],
      :unit_types => [nil, nil, nil, nil],
    },

    [ 'border-top-width',
      'border-right-width',
      'border-bottom-width',
      'border-left-width' ] => {
      :values => ['thin', 'medium', 'thick', '10px', 'inherit'],
      :unit_types => [nil, nil, nil, :SAC_PIXEL, nil],
    },

    'border-width' => {
      :values => ['thin', 'medium thin', 'thin medium 10px',
                        'thin thick 10px medium', 'inherit' ],
      :unit_types => [nil, [nil, nil], [nil, nil, :SAC_PIXEL],
        [nil, nil, :SAC_PIXEL, nil], nil],
    },

    'border'  => {
      :values => [ 'thin', 'thin dotted', 'thin red dotted', 'inherit'],
      :unit_types => [nil, [nil, nil], [nil, nil, nil], nil]
    },

    'bottom'  => {
      :values => ['10em', '100%', 'auto', 'inherit'],
      :unit_types => [:SAC_EM, :SAC_PERCENTAGE, nil, nil],
    },

    'caption-side'  => {
      :values => ['top', 'bottom', 'inherit'],
      :unit_types => [nil, nil, nil],
    },

    'clear' => {
      :values => ['none', 'left', 'right', 'both', 'inherit'],
      :unit_types => [nil, nil, nil, nil, nil],
    },

    'clip'  => {
      :values => ['auto', 'rect(5px, 40px, 45px, 5px)', 'inherit'],
      :unit_types => [nil, :SAC_RECT_FUNCTION, nil],
    },

    'color' => {
      :values => ['aqua', 'black', 'blue', 'fuchsia', 'gray', 'green', 'lime',
                'maroon', 'navy', 'olive', 'orange', 'purple', 'red', 'silver',
                'teal', 'white', 'yellow', '#f00', '#aabbcc'],
      :unit_types => [nil, nil, nil, nil, nil, nil, nil,
                      nil, nil, nil, nil, nil, nil, nil,
                      nil, nil, nil, :SAC_RGBCOLOR, :SAC_RGBCOLOR],
    },

    'content' => {
      :values => ['normal', 'none', '"test"', 'open-quote "foo"',
                  'url("http://example.com/test.png")', 'inherit', 'attr(foo)'],
      :unit_types => [nil, nil, :SAC_STRING_VALUE, [nil, :SAC_STRING_VALUE],
        :SAC_URI, nil, :SAC_FUNCTION],
    },

    [ 'counter-increment',
      'counter-reset' ] => {
      :values => ['foo 10', 'foo', 'none', 'foo 10 bar 20','inherit'],
      :unit_types => [[nil, :SAC_INTEGER], nil, nil,
        [nil, :SAC_INTEGER, nil, :SAC_INTEGER], nil],
    },

    [ 'cue-after',
      'cue-before' ]  => {
      :values => ['none', 'url("http://tenderlovemaking.com")',
                          'inherit'],
      :unit_types => [nil, :SAC_URI, nil],
    },

    'cue' => {
      :values => ['none url("http://tenderlovemaking.com")', 'none', 'inherit'],
      :unit_types => [[nil, :SAC_URI], nil, nil],
    },

    'cursor'  => {
      :values => [ 'url("http://tenderlovemaking.com"), url("http://tenderlovemaking.com") auto', 'inherit' ] +
                 [
                  'auto', 'crosshair', 'default', 'pointer', 'move',
                  'e-resize', 'ne-resize', 'nw-resize', 'n-resize',
                  'se-resize', 'sw-resize', 's-resize', 'w-resize', 'text',
                  'wait', 'help', 'progress' ].map { |x|
                    "url(\"http://tenderlovemaking.com/\") #{x}"
                 },
      :unit_types => [[:SAC_URI, :SAC_URI, nil], nil] + [[:SAC_URI, nil]] * 17,
    },

    'direction' => {
      :values => [  'ltr', 'rtl', 'inherit' ],
      :unit_types => [nil, nil, nil],
    },

    'display' => {
      :values => [  'inline', 'block', 'list-item', 'run-in', 'inline-block',
                    'table', 'inline-table', 'table-row-group',
                    'table-header-group', 'table-footer-group', 'table-row',
                    'table-column-group', 'table-column', 'table-cell',
                    'table-caption', 'none', 'inherit' ],
      :unit_types => [nil] * 17,
    },

    'elevation' => {
      :values => ['98deg', 'below', 'level', 'above', 'higher', 'lower',
                    'inherit'],
      :unit_types => [:SAC_DEGREE] + [nil] * 6,
    },

    'empty-cells' => {
      :values => ['show', 'hide', 'inherit'],
      :unit_types => [nil, nil, nil],
    },

    'float'       => {
      :values => ['left', 'right', 'none', 'inherit'],
      :unit_types => [nil, nil, nil, nil],
    },

    'font-family' => {
      :values => ['Gill', 'Gill, serif', '"Aaron P", sans-serif',
                      'serif, sans-serif', 'serif', 'sans-serif', 'cursive',
                      'fantasy', 'monospace', 'inherit' ],
      :unit_types => [nil, [nil, nil], [:SAC_STRING_VALUE, nil], [nil, nil],
                      nil, nil],
    },

    'font-size'   => {
      :values => ['xx-small', 'x-small', 'small', 'medium', 'large',
                      'x-large', 'xx-large', 'larger', 'smaller', '10in',
                      '50%', 'inherit'],
      :unit_types => [nil] * 9 + [:SAC_INCH, :SAC_PERCENTAGE, nil]
    },

    'font-style'  => {
      :values => ['normal', 'italic', 'oblique', 'inherit'],
      :unit_types => [nil] * 4,
    },

    'font-variant'=> {
      :values => ['normal', 'small-caps', 'inherit'],
      :unit_types => [nil] * 3,
    },

    'font-weight' => {
      :values => ['normal', 'bold', 'bolder', 'lighter', '100', '200',
                      '300', '400', '500', '600', '700', '800', '900',
                      'inherit'],
      :unit_types => ([nil] * 4) + ([:SAC_INTEGER] * 9) + [nil],
    },

    'font'        => {
      :values => ['x-large/110% "New Century Schoolbook", serif',
                      '12px/14px sans-serif', 'message-box', 'small-caption',
                      '80% sans-serif', 'caption', 'icon', 'menu',
                      'bold italic large Palatino, serif', 'status-bar',
                      'normal small-caps 120%/120% fantasy',
                    ],
      :unit_types => [[nil, :SAC_PERCENTAGE, :SAC_STRING_VALUE, nil],
        [:SAC_PIXEL, :SAC_PIXEL, nil], nil, nil,
        [:SAC_PERCENTAGE, nil], nil, nil, nil,
        [nil] * 5, nil, [nil, nil, :SAC_PERCENTAGE, :SAC_PERCENTAGE, nil]],
    },

    ['height','left','right','top'] => {
      :values => ['100px', '100%', 'auto', 'inherit'],
      :unit_types => [:SAC_PIXEL, :SAC_PERCENTAGE, nil, nil ],
    },

    'letter-spacing'  => {
      :values => ['normal', '100em', 'inherit'],
      :unit_types => [nil, :SAC_EM, nil ],
    },

    'line-height' => {
      :values => ['normal', '55', '100px', '49%', 'inherit'],
      :unit_types => [nil, :SAC_INTEGER, :SAC_PIXEL, :SAC_PERCENTAGE, nil],
    },

    'list-style-image'  => {
      :values => ['url("http://tenderlovemaking.com")', 'none',
                            'inherit'],
      :unit_types => [ :SAC_URI, nil, nil ]
    },

    'list-style-position' => {
      :values => ['inside', 'outside', 'inherit'],
      :unit_types => [nil, nil, nil],
    },

    'list-style-type' => {
      :values => ['disc', 'circle', 'square', 'decimal',
                          'decimal-leading-zero', 'lower-roman', 'upper-roman',
                          'lower-greek', 'lower-latin', 'upper-latin',
                          'armenian', 'georgian', 'lower-alpha', 'upper-alpha',
                          'none', 'inherit'],
      :unit_types => [nil] * 16,
    },

    'list-style' => {
      :values => ['disc', 'inside', 'url("http://tenderlovemaking.com")',
                    'disc url("http://tenderlovemaking.com") inside',
                    'inherit'],
      :unit_types => [nil, nil, :SAC_URI, [nil, :SAC_URI, nil], nil],
    },

    [ 'margin-right',
      'margin-left',
      'margin-top',
      'margin-bottom' ] => {
      :values => ['100px', '50%', 'auto' ],
      :unit_types => [:SAC_PIXEL, :SAC_PERCENTAGE, nil],
    },

    'margin' => {
      :values => ['auto', '100px', '50%', 'auto 100px', '100px 54% auto',
                'auto 100px 90px 85px'],
      :unit_types => [nil, :SAC_PIXEL, :SAC_PERCENTAGE, [nil, :SAC_PIXEL],
        [:SAC_PIXEL, :SAC_PERCENTAGE, nil],
        [nil, :SAC_PIXEL, :SAC_PIXEL, :SAC_PIXEL]],
    },

    [ 'max-height',
      'max-width' ] => {
      :values => ['10px', '60%', 'none', 'inherit'],
      :unit_types => [:SAC_PIXEL, :SAC_PERCENTAGE, nil, nil],
    },

    [ 'min-height',
      'min-width' ] => {
      :values => ['10px', '60%', 'inherit'],
      :unit_types => [:SAC_PIXEL, :SAC_PERCENTAGE, nil],
    },

    'orphans' => {
      :values => ['1000', 'inherit'],
      :unit_types => [:SAC_INTEGER, nil],
    },

    'outline-color' => {
      :values => ['red', '#ddd', '#ab12ff', 'invert', 'inherit'],
      :unit_types => [nil, :SAC_RGBCOLOR, :SAC_RGBCOLOR, nil, nil]
    },

    'outline-style' => {
      :values => ['none', 'hidden', 'dotted', 'dashed', 'solid', 'double',
                        'groove', 'ridge', 'inset', 'outset', 'inherit'],
      :unit_types => [nil] * 11,
    },

    'outline-width' => {
      :values => ['thin', 'thick', 'medium', '100in'],
      :unit_types => [nil, nil, nil, :SAC_INCH],
    },

    'outline' => {
      :values => ['red', 'hidden', '100in', 'hidden 100in red', 'hidden red',
                  '100in red', 'inherit'],
      :unit_types => [nil, nil, :SAC_INCH, [nil, :SAC_INCH, nil], [nil, nil],
        [:SAC_INCH, nil], nil],
    },

    'overflow'  => {
      :values => ['visible', 'hidden', 'scroll', 'auto', 'inherit'],
      :unit_types => [nil] * 5,
    },

    [ 'padding-top',
      'padding-right',
      'padding-bottom',
      'padding-left' ]  => {
      :values => [ '100in', '100%', 'inherit' ],
      :unit_types => [ :SAC_INCH, :SAC_PERCENTAGE, nil],
    },

    'padding' => ['100in', '100in 100%', '2em 4in 5ex', '1ex 100% 5% 2%',
                  'inherit' ],
    [ 'page-break-after',
      'page-break-before' ] => ['auto', 'always', 'avoid', 'left', 'right',
                                'inherit'],
    'page-break-inside' => ['avoid', 'auto', 'inherit'],
    [ 'pause-after',
      'pause-before' ]  => ['123ms', '321s', '10%', 'inherit'],
    'pause' => ['10ms 19%', '10s 10ms', '10ms', 'inherit' ],
    'pitch-range' => ['1000', 'inherit'],
    'pitch' => ['10Hz', '100kHz', 'x-low', 'low', 'medium', 'high', 'x-high',
                'inherit'],
    'play-during' => ['url("http://tenderlovemaking.com/")',
                      'url("http://tenderlovemaking.com/") mix',
                      'url("http://tenderlovemaking.com/") repeat mix',
                      'auto', 'none', 'inherit'],
    'position'  => ['static', 'relative', 'absolute', 'fixed', 'inherit'],
    'quotes'  => ['"one" "two"', 'none', 'inherit'],
    'richness'  => ['1000', 'inherit'],
    'speak-header'  => ['once', 'always', 'inherit'],
    'speak-numeral' => ['digits', 'continuous', 'inherit'],
    'speak-punctuation' => ['code', 'none', 'inherit'],
    'speak' => ['normal', 'none', 'spell-out', 'inherit'],
    'speech-rate' => ['1000', 'x-slow', 'slow', 'medium', 'fast', 'x-fast',
                      'faster', 'slower', 'inherit'],
    'stress'  => ['69', 'inherit'],
    'table-layout'  => ['auto', 'fixed', 'inherit'],
    'text-align' => ['left', 'right', 'center', 'justify', 'inherit'],
    'text-decoration' => ['none', 'underline', 'overline underline',
                          'blink line-through underline',
                          'underline blink overline line-through', 'inherit'],
    'text-indent' => ['69in', '69%', 'inherit'],
    'text-transform'  => ['capitalize', 'uppercase', 'lowercase', 'none',
                          'inherit'],
    'unicode-bidi' => ['normal', 'embed', 'bidi-override', 'inherit'],
    'vertical-align'  => ['baseline', 'sub', 'super', 'top', 'text-top',
                          'middle', 'bottom', 'text-bottom', '70%', '100in',
                          'inherit'],
    'visibility' => ['visible', 'hidden', 'collapse', 'inherit'],
    'voice-family' => ['romeo, male', 'juliet, female', 'male', 'male, female',
                        'inherit'],
    'volume'  => ['10', '10%', 'silent', 'x-soft', 'soft', 'medium', 'loud',
                  'x-loud', 'inherit'],
    'white-space' => ['normal', 'pre', 'nowrap', 'pre-wrap', 'pre-line',
                      'inherit'],
    'windows' => ['169', 'inherit'],
    'width' => ['100em', '50%', 'auto', 'inherit'],
    'word-spacing'  => ['normal', '10in', 'inherit'],
    'z-index' => ['auto', '10', 'inherit'],
  }

  @@valid_value_tests.each do |k,v|
    [k].flatten.each do |key|
      define_method :"test_valid_#{key.to_s.gsub(/-/, '_')}" do
        v[:values].each_with_index do |value, i|
          tok = @tokenizer.tokenize("#{key}: #{value}")
          result = @property_parser.parse_tokens(tok)
          if result.nil?
            p tok
          end
          assert_not_nil(result)

          unit_types = [v[:unit_types][i] || :SAC_IDENT].flatten.map { |x|
            x || :SAC_IDENT
          }
          result_types = [result].flatten.map { |x| x.lexical_unit_type }

          assert_equal(unit_types, result_types, tok.inspect)
        end
      end
    end
  end
end
