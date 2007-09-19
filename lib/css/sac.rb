module CSS
  class SAC
  end
end

require 'css/document_handler'

class CSS::SAC
  attr_reader :tokens
  attr_accessor :document_handler

  def initialize
    @lexer_tokens = {}
    @macros       = {}
    @tokens       = []

    # http://www.w3.org/TR/CSS21/syndata.html
    macro(:unicode,       /\\[0-9a-f]{1,6}(\r\n|[ \n\r\t\f])?/)
    macro(:w,             /[ \t\r\n\f]*/)
    macro(:nonascii,      /[^\0-\177]/)
    macro(:num,           /[0-9]+|[0-9]*\.[0-9]+/)
    macro(:nl,            /\n|\r\n|\r|\f/)
    macro(:escape,        /(#{m(:unicode)}|\\[^\n\r\f0-9a-f])/)
    macro(:nmstart,       /([_a-z]|#{m(:nonascii)}|#{m(:escape)})/)
    macro(:nmchar,        /([_a-z0-9-]|#{m(:nonascii)}|#{m(:escape)})/)
    macro(:name,          /#{m(:nmchar)}+/i)
    macro(:ident,         /[-]?#{m(:nmstart)}#{m(:nmchar)}*/)
    macro(:string1,       /(\"([^\n\r\f\\"]|\\#{m(:nl)}|#{m(:escape)})*\")/)
    macro(:string2,       /\'([^\n\r\f\\']|\\#{m(:nl)}|#{m(:escape)})*\'/)
    macro(:string,        /#{m(:string1)}|#{m(:string2)}/)
    macro(:invalid1,      /\"([^\n\r\f\\"]|\\#{m(:nl)}|#{m(:escape)})*/)
    macro(:invalid2,      /\'([^\n\r\f\\']|\\#{m(:nl)}|#{m(:escape)})*/)
    macro(:invalid,       /#{m(:invalid1)}|#{m(:invalid2)}/)

    token(:ident,         /#{m(:ident)}/)
    token(:atkeyword,     /@#{m(:ident)}/)
    token(:string,        /#{m(:string)}/)
    token(:invalid,       /#{m(:invalid)}/)
    token(:hash,          /##{m(:name)}/)
    token(:number,        /#{m(:num)}/)
    token(:percentage,    /(#{m(:num)})%/)
    token(:dimension,     /#{m(:num)}#{m(:ident)}/)
    token(:unicode_range, /U\+[0-9a-f?]{1,6}(-[0-9a-f]{1,6})?/)
    token(:cdo,           /<!--/)
    token(:cdc,           /-->/)
    token(:semi,          /;/)
    token(:l_curly,       /\{/)
    token(:r_curly,       /\}/)
    token(:l_paren,       /\(/)
    token(:r_paren,       /\)/)
    token(:l_square,      /\[/)
    token(:r_square,      /\]/)
    token(:s,             /[ \t\r\n\f]+/)
    token(:comment,       /\/\*[^*]*\*+([^\/*][^*]*\*+)*\//)
    token(:function,      /#{m(:ident)}\(/)
    token(:includes,      /~=/)
    token(:dashmatch,     /\|=/)
    token(:uri,           /url\(#{m(:w)}#{m(:string)}#{m(:w)}\)|url\(#{m(:w)}([!#\$%&*-~]|#{m(:nonascii)}|#{m(:escape)})*#{m(:w)}\)/)

    yield self if block_given?
    @document_handler ||= DocumentHandler.new()
  end

  def parse_style_sheet(string)
    self.document_handler.start_document(string)
    tokenize(string)
    @position = 0
    stylesheet
    self.document_handler.end_document(string)
    self.document_handler
  end

  alias :parseStyleSheet :parse_style_sheet
  alias :parse :parse_style_sheet

  def tokenize(string)
    @tokens = []
    pos     = 0
    until string.empty?
      tokens = @lexer_tokens.values.map { |tok|
        match = tok.lex_pattern.match(string) || next
        next unless match.pre_match.length == 0 && match.to_s.length > 0
        Token.new(tok.name, match.to_s, pos)
      }.compact.sort_by { |x| x.value.length }

      if tokens.length == 0
        match   = /^./.match(string)
        tokens  = [Token.new(:delim, match.to_s, pos)]
      end

      token = tokens.last
      @tokens << token
      string = string.slice(Range.new(token.value.length, -1))
      pos += token.value.length
    end
  end

  private
  def stylesheet
    statements = []
    while(has_token?)
      next_token(:cdc)
      next_token(:cdo)
      next_token(:s)
      statements << statement()
    end
    statements
  end

  def statement
    ruleset || at_rule
  end

  def at_rule
    start = @position
    at_value = []
    if at_keyword = next_token(:atkeyword)
      zero_or_more(:s)
      loop { tok = any || break; at_value << tok }

      page_name = pseudo_page = nil
      case at_keyword.value
      when '@import'
        self.document_handler.import_style(
          at_value.shift.value,
          at_value.map { |x| x.value }
        )
      when '@media'
        self.document_handler.start_media(at_value.map { |x| x.value })
      when '@page'
        if at_value.first.name != :delim
          page_name = at_value.shift.value
        end
        if at_value.length > 0
          pseudo_page = at_value.last.value
        end
        self.document_handler.start_page(page_name, pseudo_page)
      when '@font-face'
        self.document_handler.start_font_face
      else
        self.document_handler.ignorable_at_rule(at_keyword.value)
      end
      return false unless block || next_token(:semi)
      zero_or_more(:s)

      case at_keyword.value
      when '@media'
        self.document_handler.end_media(at_value.map { |x| x.value })
      when '@page'
        self.document_handler.end_page(page_name, pseudo_page)
      when '@font-face'
        self.document_handler.end_font_face
      end
      return true
    end
    @position = start
    false
  end

  def block
    start = @position
    if next_token(:l_curly) && zero_or_more(:s)
      vals = []
      while(v = any || block || next_token(:atkeyword) && zero_or_more(:s) || next_token(:semi) && zero_or_more(:s))
        vals << v
      end
      if next_token(:r_curly) && zero_or_more(:s)
        return true
      end
    end
    @position = start
    return false
  end

  def any
    [:ident, :number, :percentage, :dimension, :string, :delim, :uri,
      :hash, :unicode_range, :includes, :dashmatch].each { |name|
      token = next_token(name)
      zero_or_more(:s)
      return token if token
    }
    # FIXME: Needs to support:
    # FUNCTION S* any* ')' | '(' S* any* ')' | '[' S* any* ']' ] S*;
    return nil
  end

  def ruleset
    select = selector
    return nil unless select
    self.document_handler.start_selector(select.map { |x| x.value })
    start = @position
    return nil unless next_token(:l_curly)
    zero_or_more(:s)

    loop {
      break if next_token(:r_curly)
      next if next_token(:semi)
      zero_or_more(:s)
      (name, val) = declaration
      next unless name && val

      important = false
      if val.reverse.slice(0, 2).map { |x| x.value } == ['important', '!']
        important = true
        val.slice!(-2..-1)
      end
      self.document_handler.property(name.value,
                                     val.map { |x| x.value },
                                     important)
    }
    self.document_handler.end_selector(select.map { |x| x.value })
    zero_or_more(:s)
  end

  def declaration
    next_token(:delim)
    zero_or_more(:s)
    prop = property()
    zero_or_more(:s)

    tok = next_token(:delim)
    tok && tok.value == ':'
    zero_or_more(:s)
    val = value()
    (prop && val) ? [prop, val] : nil
  end

  def property
    next_token(:ident)
  end

  def selector
    selectors = []
    while s = any
      selectors << s
    end
    selectors
  end

  def value
    values = []
    while v = (any() || block() || next_token(:atkeyword) && zero_or_more(:s))
      values << v
    end
    return nil if values.flatten.compact.length == 0
    values
  end

  def zero_or_more(name)
    list = []
    while tok = next_token(name)
      list << tok
    end
    list
  end

  LexToken = Struct.new(:name, :pattern, :lex_pattern, :block)
  Token = Struct.new(:name, :value, :pos)

  def token(name, pattern = nil, &block)
    @lexer_tokens[name] = LexToken.new(
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

  def next_token(token_name)
    token = @tokens[@position]
    if token && token.name == token_name
      @position += 1
      return token
    end
    nil
  end

  def has_token?
    @position < @tokens.length
  end
end
