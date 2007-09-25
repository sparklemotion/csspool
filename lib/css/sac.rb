require 'racc/parser'
require 'css/parser'
require 'css/tokens'
require 'css/document_handler'

class CSS::SAC < Racc::Parser
  attr_reader :tokens
  attr_accessor :document_handler

  def initialize
    @lexer_tokens = []
    @macros       = {}
    @tokens       = []

    # http://www.w3.org/TR/CSS21/syndata.html
    macro(:h, /([0-9a-f])/ )
    macro(:nonascii, /([\200-\377])/ )
    macro(:nl, /(\n|\r\n|\r|\f)/ )
    macro(:unicode, /(\\#{m(:h)}{1,6}(\r\n|[ \t\r\n\f])?)/ )
    macro(:escape, /(#{m(:unicode)}|\\[^\r\n\f0-9a-f])/ )
    macro(:nmstart, /([_a-z]|#{m(:nonascii)}|#{m(:escape)})/ )
    macro(:nmchar, /([_a-z0-9-]|#{m(:nonascii)}|#{m(:escape)})/ )
    macro(:string1, /(\"([^\n\r\f\\\"]|\\#{m(:nl)}|#{m(:escape)})*\")/ )
    macro(:string2, /(\'([^\n\r\f\\']|\\#{m(:nl)}|#{m(:escape)})*\')/ )
    macro(:invalid1, /(\"([^\n\r\f\\\"]|\\#{m(:nl)}|#{m(:escape)})*)/ )
    macro(:invalid2, /(\'([^\n\r\f\\']|\\#{m(:nl)}|#{m(:escape)})*)/ )
    macro(:comment, /(\/\*[^*]*\*+([^\/*][^*]*\*+)*\/)/ )
    macro(:ident, /(-?#{m(:nmstart)}#{m(:nmchar)}*)/ )
    macro(:name, /(#{m(:nmchar)}+)/ )
    macro(:num, /([0-9]+|[0-9]*\.[0-9]+)/ )
    macro(:string, /(#{m(:string1)}|#{m(:string2)})/ )
    macro(:invalid, /(#{m(:invalid1)}|#{m(:invalid2)})/ )
    macro(:url, /(([!#\$%&*-~]|#{m(:nonascii)}|#{m(:escape)})*)/ )
    macro(:s, /([ \t\r\n\f]+)/ )
    macro(:w, /(#{m(:s)}?)/ )
    macro(:A, /(a|\\0{0,4}(41|61)(\r\n|[ \t\r\n\f])?)/ )
    macro(:C, /(c|\\0{0,4}(43|63)(\r\n|[ \t\r\n\f])?)/ )
    macro(:D, /(d|\\0{0,4}(44|64)(\r\n|[ \t\r\n\f])?)/ )
    macro(:E, /(e|\\0{0,4}(45|65)(\r\n|[ \t\r\n\f])?)/ )
    macro(:G, /(g|\\0{0,4}(47|67)(\r\n|[ \t\r\n\f])?|\\g)/ )
    macro(:H, /(h|\\0{0,4}(48|68)(\r\n|[ \t\r\n\f])?|\\h)/ )
    macro(:I, /(i|\\0{0,4}(49|69)(\r\n|[ \t\r\n\f])?|\\i)/ )
    macro(:K, /(k|\\0{0,4}(4b|6b)(\r\n|[ \t\r\n\f])?|\\k)/ )
    macro(:M, /(m|\\0{0,4}(4d|6d)(\r\n|[ \t\r\n\f])?|\\m)/ )
    macro(:N, /(n|\\0{0,4}(4e|6e)(\r\n|[ \t\r\n\f])?|\\n)/ )
    macro(:O, /(o|\\0{0,4}(51|71)(\r\n|[ \t\r\n\f])?|\\o)/ )
    macro(:P, /(p|\\0{0,4}(50|70)(\r\n|[ \t\r\n\f])?|\\p)/ )
    macro(:R, /(r|\\0{0,4}(52|72)(\r\n|[ \t\r\n\f])?|\\r)/ )
    macro(:S, /(s|\\0{0,4}(53|73)(\r\n|[ \t\r\n\f])?|\\s)/ )
    macro(:T, /(t|\\0{0,4}(54|74)(\r\n|[ \t\r\n\f])?|\\t)/ )
    macro(:X, /(x|\\0{0,4}(58|78)(\r\n|[ \t\r\n\f])?|\\x)/ )
    macro(:Z, /(z|\\0{0,4}(5a|7a)(\r\n|[ \t\r\n\f])?|\\z)/ )
    
    token(:S, /#{m(:s)}/)
    token(:COMMENT, /\/\*[^*]*\*+([^\/*][^*]*\*+)*\//)
    token(:COMMENT, /#{m(:s)}+\/\*[^*]*\*+([^\/*][^*]*\*+)*\//)
    token(:CDO, /<!--/)
    token(:CDC, /-->/)
    token(:INCLUDES, /~=/)
    token(:DASHMATCH, /\|=/)
    token(:LBRACE, /#{m(:w)}\{/)
    token(:PLUS, /#{m(:w)}\+/)
    token(:GREATER, /#{m(:w)}>/)
    token(:COMMA, /#{m(:w)},/)
    token(:STRING, /#{m(:string)}/)
    token(:INVALID, /#{m(:invalid)}/)
    token(:IDENT, /#{m(:ident)}/)
    token(:HASH, /##{m(:name)}/)
    token(:IMPORT_SYM, /@#{m(:I)}#{m(:M)}#{m(:P)}#{m(:O)}#{m(:R)}#{m(:T)}/)
    token(:PAGE_SYM, /@#{m(:P)}#{m(:A)}#{m(:G)}#{m(:E)}/)
    token(:MEDIA_SYM, /@#{m(:M)}#{m(:E)}#{m(:D)}#{m(:I)}#{m(:A)}/)
    token(:CHARSET_SYM, /@#{m(:C)}#{m(:H)}#{m(:A)}#{m(:R)}#{m(:S)}#{m(:E)}#{m(:T)}/)
    token(:IMPORTANT_SYM, /!(#{m(:w)}|#{m(:comment)})*#{m(:I)}#{m(:M)}#{m(:P)}#{m(:O)}#{m(:R)}#{m(:T)}#{m(:A)}#{m(:N)}#{m(:T)}/)
    token(:EMS, /#{m(:num)}#{m(:E)}#{m(:M)}/)
    token(:EXS, /#{m(:num)}#{m(:E)}#{m(:X)}/)
    token(:LENGTH, /#{m(:num)}#{m(:P)}#{m(:X)}/)
    token(:LENGTH, /#{m(:num)}#{m(:C)}#{m(:M)}/)
    token(:LENGTH, /#{m(:num)}#{m(:M)}#{m(:M)}/)
    token(:LENGTH, /#{m(:num)}#{m(:I)}#{m(:N)}/)
    token(:LENGTH, /#{m(:num)}#{m(:P)}#{m(:T)}/)
    token(:LENGTH, /#{m(:num)}#{m(:P)}#{m(:C)}/)
    token(:ANGLE, /#{m(:num)}#{m(:D)}#{m(:E)}#{m(:G)}/)
    token(:ANGLE, /#{m(:num)}#{m(:R)}#{m(:A)}#{m(:D)}/)
    token(:ANGLE, /#{m(:num)}#{m(:G)}#{m(:R)}#{m(:A)}#{m(:D)}/)
    token(:TIME, /#{m(:num)}#{m(:M)}#{m(:S)}/)
    token(:TIME, /#{m(:num)}#{m(:S)}/)
    token(:FREQ, /#{m(:num)}#{m(:H)}#{m(:Z)}/)
    token(:FREQ, /#{m(:num)}#{m(:K)}#{m(:H)}#{m(:Z)}/)
    token(:DIMENSION, /#{m(:num)}#{m(:ident)}/)
    token(:PERCENTAGE, /#{m(:num)}%/)
    token(:NUMBER, /#{m(:num)}/)
    token(:URI, /url\(#{m(:w)}#{m(:string)}#{m(:w)}\)/)
    token(:URI, /url\(#{m(:w)}#{m(:url)}#{m(:w)}\)/)
    token(:FUNCTION, /#{m(:ident)}\(\)/)


    yield self if block_given?
    @document_handler ||= DocumentHandler.new()
  end

  def parse_style_sheet(string)
    @yydebug = true
    tokenize(string)
    @position = 0
    self.document_handler.start_document(string)
    do_parse
    self.document_handler.end_document(string)
  end

  alias :parseStyleSheet :parse_style_sheet
  alias :parse :parse_style_sheet

  def next_token
    return [false, false] if @position >= @tokens.length 

    n_token = @tokens[@position]
    @position += 1
    if n_token.name == :COMMENT
      self.document_handler.comment(n_token.value)
      return next_token
    end
    n_token.to_yacc
  end

  def on_error(error_token_id, error_value, value_stack)
    puts '#' * 50
    puts token_to_str(error_token_id)
    p error_value
    p value_stack
    puts '#' * 50
  end

  def tokenize(string)
    @tokens = []
    pos     = 0
    until string.empty?
      tokens = @lexer_tokens.map { |tok|
        match = tok.lex_pattern.match(string) || next
        next unless match.pre_match.length == 0 && match.to_s.length > 0
        Token.new(tok.name, match.to_s, pos)
      }.compact.sort_by { |x| x.value.length }

      if tokens.length == 0
        match   = /^./.match(string)
        tokens  = [DelimToken.new(:delim, match.to_s, pos)]
      end

      token = tokens.last
      @tokens << token
      string = string.slice(Range.new(token.value.length, -1))
      pos += token.value.length
    end
  end

  def token(name, pattern = nil, &block)
    @lexer_tokens << LexToken.new(
      name,
      pattern,
      Regexp.new('^' + pattern.source, Regexp::IGNORECASE),
      block
    )
  end

  def macro(name, regex = nil)
    regex ? @macros[name] = regex : @macros[name].source
  end
  alias :m :macro
end
