module CSS
  class SAC
  end
end

require 'css/document_handler'

class CSS::SAC
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
    
    token(/#{m(:s)}/) { return :S }
    token(/\/\*[^*]*\*+([^\/*][^*]*\*+)*\//)
    token(/#{m(:s)}+\/\*[^*]*\*+([^\/*][^*]*\*+)*\//) {unput(' ')}
    token(/<!--/) {return :CDO}
    token(/-->/) {return :CDC;}
    token(/~=/) {return :INCLUDES;}
    token(/\|=/) {return :DASHMATCH;}
    token(/#{m(:w)}\{/) {return :LBRACE;}
    token(/#{m(:w)}\+/) {return :PLUS;}
    token(/#{m(:w)}>/) {return :GREATER;}
    token(/#{m(:w)},/) {return :COMMA;}
    token(/#{m(:string)}/) {return :STRING;}
    token(/#{m(:invalid)}/) {return :INVALID;}
    token(/#{m(:ident)}/) {return :IDENT;}
    token(/##{m(:name)}/) {return :HASH;}
    token(/@#{m(:I)}#{m(:M)}#{m(:P)}#{m(:O)}#{m(:R)}#{m(:T)}/) {return :IMPORT_SYM;}
    token(/@#{m(:P)}#{m(:A)}#{m(:G)}#{m(:E)}/) {return :PAGE_SYM;}
    token(/@#{m(:M)}#{m(:E)}#{m(:D)}#{m(:I)}#{m(:A)}/) {return :MEDIA_SYM;}
    token(/@#{m(:C)}#{m(:H)}#{m(:A)}#{m(:R)}#{m(:S)}#{m(:E)}#{m(:T)}/) {return :CHARSET_SYM;}
    token(/!(#{m(:w)}|#{m(:comment)})*#{m(:I)}#{m(:M)}#{m(:P)}#{m(:O)}#{m(:R)}#{m(:T)}#{m(:A)}#{m(:N)}#{m(:T)}/) {return :IMPORTANT_SYM;}
    token(/#{m(:num)}#{m(:E)}#{m(:M)}/) {return :EMS;}
    token(/#{m(:num)}#{m(:E)}#{m(:X)}/) {return :EXS;}
    token(/#{m(:num)}#{m(:P)}#{m(:X)}/) {return :LENGTH;}
    token(/#{m(:num)}#{m(:C)}#{m(:M)}/) {return :LENGTH;}
    token(/#{m(:num)}#{m(:M)}#{m(:M)}/) {return :LENGTH;}
    token(/#{m(:num)}#{m(:I)}#{m(:N)}/) {return :LENGTH;}
    token(/#{m(:num)}#{m(:P)}#{m(:T)}/) {return :LENGTH;}
    token(/#{m(:num)}#{m(:P)}#{m(:C)}/) {return :LENGTH;}
    token(/#{m(:num)}#{m(:D)}#{m(:E)}#{m(:G)}/) {return :ANGLE;}
    token(/#{m(:num)}#{m(:R)}#{m(:A)}#{m(:D)}/) {return :ANGLE;}
    token(/#{m(:num)}#{m(:G)}#{m(:R)}#{m(:A)}#{m(:D)}/) {return :ANGLE;}
    token(/#{m(:num)}#{m(:M)}#{m(:S)}/) {return :TIME;}
    token(/#{m(:num)}#{m(:S)}/) {return :TIME;}
    token(/#{m(:num)}#{m(:H)}#{m(:Z)}/) {return :FREQ;}
    token(/#{m(:num)}#{m(:K)}#{m(:H)}#{m(:Z)}/) {return :FREQ;}
    token(/#{m(:num)}#{m(:ident)}/) {return :DIMENSION;}
    token(/#{m(:num)}%/) {return :PERCENTAGE;}
    token(/#{m(:num)}/) {return :NUMBER;}
    token(/url\(#{m(:w)}#{m(:string)}#{m(:w)}\)/) {return :URI;}
    token(/url\(#{m(:w)}#{m(:url)}#{m(:w)}\)/) {return :URI;}
    token(/#{m(:ident)}\(\)/) {return :FUNCTION;}


    yield self if block_given?
    @document_handler ||= DocumentHandler.new()
  end

  def parse_style_sheet(string)
    self.document_handler.start_document(string)
    tokenize(string)
    @position = 0
    #stylesheet
    self.document_handler.end_document(string)
    self.document_handler
  end

  alias :parseStyleSheet :parse_style_sheet
  alias :parse :parse_style_sheet

  def tokenize(string)
    @tokens = []
    pos     = 0
    until string.empty?
      tokens = @lexer_tokens.map { |tok|
        match = tok.lex_pattern.match(string) || next
        next unless match.pre_match.length == 0 && match.to_s.length > 0
        Token.new(tok, match.to_s, pos)
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

  LexToken = Struct.new(:pattern, :lex_pattern, :block)
  Token = Struct.new(:name, :value, :pos)

  def token(pattern = nil, &block)
    @lexer_tokens << LexToken.new(
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
