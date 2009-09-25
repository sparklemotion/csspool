# -*- coding: utf-8 -*-

require "helper"

module CSSPool
  module CSS
    class TestTokenizer < CSSPool::TestCase
      def setup
        super
        @scanner = Class.new(CSSPool::CSS::Tokenizer) {
          def do_parse
          end
        }.new
      end

      {
        'em'    => :EMS,
        'ex'    => :EXS,
        'px'    => :LENGTH,
        'cm'    => :LENGTH,
        'mm'    => :LENGTH,
        'in'    => :LENGTH,
        'pt'    => :LENGTH,
        'pc'    => :LENGTH,
        'deg'   => :ANGLE,
        'rad'   => :ANGLE,
        'grad'  => :ANGLE,
        'ms'    => :TIME,
        's'     => :TIME,
        'hz'    => :FREQ,
        'khz'   => :FREQ,
        '%'     => :PERCENTAGE,
      }.each do |unit,sym|
        define_method :"test_#{unit}" do
          ['10', '0.1'].each do |num|
            num = "#{num}#{unit}"
            [num, "  #{num}", "#{num}  ", " #{num} "].each do |str|
              @scanner.scan str
              assert_tokens([[sym, str]], @scanner)
            end
          end
        end
      end

      def test_num
        ['10', '0.1'].each do |num|
          [num, "  #{num}", "#{num}  ", " #{num} "].each do |str|
            @scanner.scan str
            assert_tokens([[:NUMBER, str]], @scanner)
          end
        end
      end

      def test_important
        [
          '!important',
          '  !important',
          '!important  ',
          '!  important  ',
          '  !  important  ',
        ].each do |str|
          @scanner.scan str
          assert_tokens([[:IMPORTANT_SYM, str]], @scanner)
        end
      end

      {
        '@page'     => :PAGE_SYM,
        '@import'   => :IMPORT_SYM,
        '@media'    => :MEDIA_SYM,
        '@charset'  => :CHARSET_SYM,
      }.each do |k,v|
        define_method(:"test_#{k.sub(/@/, '')}") do
          [k, "  #{k}", "#{k}  ", " #{k} "].each do |str|
            @scanner.scan str
            assert_tokens([[v, str]], @scanner)
          end
        end
      end

      def test_invalid
        str = "'internet"
        @scanner.scan str
        assert_tokens([[:INVALID, str]], @scanner)

        str = '"internet'
        @scanner.scan str
        assert_tokens([[:INVALID, str]], @scanner)
      end

      def test_comment
        str = "/**** Hello World ***/"
        @scanner.scan str
        assert_tokens([[:COMMENT, str]], @scanner)

        str = "/* Hello World */"
        @scanner.scan str
        assert_tokens([[:COMMENT, str]], @scanner)
      end

      def test_rbrace
        str = "  }  \n  "
        @scanner.scan str
        assert_tokens([[:RBRACE, str]], @scanner)
      end

      def test_lbrace
        str = "  {    "
        @scanner.scan str
        assert_tokens([[:LBRACE, str]], @scanner)
      end

      def test_semi
        str = "  ;    "
        @scanner.scan str
        assert_tokens([[:SEMI, ';']], @scanner)
      end

      def test_cdc
        @scanner.scan("-->")
        assert_tokens([[:CDC, "-->"]], @scanner)
      end

      def test_cdo
        @scanner.scan("<!--")
        assert_tokens([[:CDO, "<!--"]], @scanner)
      end

      def test_unicode_range
        @scanner.scan("U+0-10FFFF")
        assert_tokens([[:UNICODE_RANGE, "U+0-10FFFF"]], @scanner)
      end

      def test_url_with_string
        @scanner.scan("url('http://tlm.com')")
        assert_tokens([[:URI, "url('http://tlm.com')"]], @scanner)
      end

      def test_url_with_others
        @scanner.scan("url(http://tlm.com?f&b)")
        assert_tokens([[:URI, "url(http://tlm.com?f&b)"]], @scanner)
      end

      def test_unicode
        @scanner.scan("a日本語")
        assert_tokens([[:IDENT, 'a日本語']], @scanner)
      end

      def test_tokenize_bad_percent
        @scanner.scan("%")
        assert_tokens([["%", "%"]], @scanner)
      end

      def test_not_equal
        @scanner.scan("h1[a!='Tender Lovemaking']")
        assert_tokens([ [:IDENT, 'h1'],
                        [:LSQUARE, '['],
                        [:IDENT, 'a'],
                        [:NOT_EQUAL, '!='],
                        [:STRING, "'Tender Lovemaking'"],
                        [:RSQUARE, ']'],
        ], @scanner)
      end

      def test_negation
        @scanner.scan("p:not(.a)")
        assert_tokens([ [:IDENT, 'p'],
                        [:NOT, ':not('],
                        ['.', '.'],
                        [:IDENT, 'a'],
                        [:RPAREN, ')'],
        ], @scanner)
      end

      def test_function
        @scanner.scan("script comment()")
        assert_tokens([ [:IDENT, 'script'],
                        [:S, ' '],
                        [:FUNCTION, 'comment('],
                        [:RPAREN, ')'],
        ], @scanner)
      end

      def test_preceding_selector
        @scanner.scan("E ~ F")
        assert_tokens([ [:IDENT, 'E'],
                        [:TILDE, ' ~ '],
                        [:IDENT, 'F'],
        ], @scanner)
      end

      def test_scan_attribute_string
        @scanner.scan("h1[a='Tender Lovemaking']")
        assert_tokens([ [:IDENT, 'h1'],
                        [:LSQUARE, '['],
                        [:IDENT, 'a'],
                        [:EQUAL, '='],
                        [:STRING, "'Tender Lovemaking'"],
                        [:RSQUARE, ']'],
        ], @scanner)
        @scanner.scan('h1[a="Tender Lovemaking"]')
        assert_tokens([ [:IDENT, 'h1'],
                        [:LSQUARE, '['],
                        [:IDENT, 'a'],
                        [:EQUAL, '='],
                        [:STRING, '"Tender Lovemaking"'],
                        [:RSQUARE, ']'],
        ], @scanner)
      end

      def test_scan_id
        @scanner.scan('#foo')
        assert_tokens([ [:HASH, '#foo'] ], @scanner)
      end

      def test_scan_pseudo
        @scanner.scan('a:visited')
        assert_tokens([ [:IDENT, 'a'],
                        [':', ':'],
                        [:IDENT, 'visited']
        ], @scanner)
      end

      def test_scan_star
        @scanner.scan('*')
        assert_tokens([ [:STAR, '*'], ], @scanner)
      end

      def test_scan_class
        @scanner.scan('x.awesome')
        assert_tokens([ [:IDENT, 'x'],
                        ['.', '.'],
                        [:IDENT, 'awesome'],
        ], @scanner)
      end

      def test_scan_greater
        @scanner.scan('x > y')
        assert_tokens([ [:IDENT, 'x'],
                        [:GREATER, ' > '],
                        [:IDENT, 'y']
        ], @scanner)
      end

      def test_scan_slash
        @scanner.scan('x/y')
        assert_tokens([ [:IDENT, 'x'],
                        [:SLASH, '/'],
                        [:IDENT, 'y']
        ], @scanner)
      end

      def test_scan_doubleslash
        @scanner.scan('x//y')
        assert_tokens([ [:IDENT, 'x'],
                        [:DOUBLESLASH, '//'],
                        [:IDENT, 'y']
        ], @scanner)
      end

      def test_scan_function_selector
        @scanner.scan('x:eq(0)')
        assert_tokens([ [:IDENT, 'x'],
                        [':', ':'],
                        [:FUNCTION, 'eq('],
                        [:NUMBER, "0"],
                        [:RPAREN, ')'],
        ], @scanner)
      end

      def test_scan_an_plus_b
        @scanner.scan('x:nth-child(5n+3)')
        assert_tokens([ [:IDENT, 'x'],
                        [':', ':'],
                        [:FUNCTION, 'nth-child('],
                        [:NUMBER, '5'],
                        [:IDENT, 'n'],
                        [:PLUS, '+'],
                        [:NUMBER, '3'],
                        [:RPAREN, ')'],
        ], @scanner)

        @scanner.scan('x:nth-child(-1n+3)')
        assert_tokens([ [:IDENT, 'x'],
                        [':', ':'],
                        [:FUNCTION, 'nth-child('],
                        [:MINUS, '-'],
                        [:NUMBER, '1'],
                        [:IDENT, 'n'],
                        [:PLUS, '+'],
                        [:NUMBER, '3'],
                        [:RPAREN, ')'],
        ], @scanner)

        @scanner.scan('x:nth-child(-n+3)')
        assert_tokens([ [:IDENT, 'x'],
                        [':', ':'],
                        [:FUNCTION, 'nth-child('],
                        [:IDENT, '-n'],
                        [:PLUS, '+'],
                        [:NUMBER, '3'],
                        [:RPAREN, ')'],
        ], @scanner)
      end

      def assert_tokens(tokens, scanner)
        toks = []
        while tok = @scanner.next_token
          toks << tok
        end
        assert_equal(tokens, toks)
      end
    end
  end
end
