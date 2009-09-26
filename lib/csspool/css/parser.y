class CSSPool::CSS::Parser

token CHARSET_SYM IMPORT_SYM STRING SEMI IDENT S COMMA LBRACE RBRACE STAR HASH
token LSQUARE RSQUARE EQUAL INCLUDES DASHMATCH RPAREN FUNCTION GREATER PLUS
token SLASH NUMBER MINUS LENGTH PERCENTAGE EMS EXS ANGLE TIME FREQ URI
token IMPORTANT_SYM MEDIA_SYM

rule
  document
    : { @document.start_document }
      stylesheet
      { @document.end_document }
    ;
  stylesheet
    : charset stylesheet
    | import stylesheet
    | charset
    | import
    | body
    ;
  charset
    : CHARSET_SYM STRING SEMI { @document.charset val[1][1..-2], {} }
    ;
  import
    : IMPORT_SYM import_location medium SEMI {
        @document.import_style [val[2]].flatten, val[1]
      }
    | IMPORT_SYM import_location SEMI {
        @document.import_style [], val[1]
      }
    ;
  import_location
    : import_location S
    | STRING { result = Terms::String.new strip_string val.first }
    | URI { result = Terms::URI.new strip_uri val.first }
    ;
  medium
    : medium COMMA IDENT { result = [val.first, Terms::Ident.new(val.last)] }
    | IDENT { result = Terms::Ident.new val.first }
    ;
  body
    : ruleset body
    | media body
    | ruleset
    | media
    ;
  media
    : start_media body RBRACE { @document.end_media val.first }
    ;
  start_media
    : MEDIA_SYM medium LBRACE {
        result = [val[1]].flatten
        @document.start_media result
      }
    | MEDIA_SYM LBRACE { result = [] }
    ;
  ruleset
    : start_selector declarations RBRACE {
        @document.end_selector Array(val.first)
      }
    | start_selector RBRACE {
        @document.end_selector Array(val.first)
      }
    ;
  start_selector
    : S start_selector
    | selectors LBRACE { @document.start_selector Array(val.first) }
    ;
  selectors
    : selector COMMA selectors
      {
        sel = Selector.new(Array(val.first), {})
        result = [sel, val[2]].flatten
      }
    | selector
      {
        result = Selector.new(Array(val.first), {})
      }
    ;
  selector
    : simple_selector combinator selector
      {
        val = val.flatten
        val[2].combinator = val.delete_at 1
        result = val
      }
    | simple_selector
    ;
  combinator
    : S       { result = :s }
    | GREATER { result = :> }
    | PLUS    { result = :+ }
    ;
  simple_selector
    : element_name hcap {
        result = val.first
        result.additional_selectors = Array(val.last).flatten
      }
    | element_name
    | hcap
      {
        result = Selectors::Simple.new nil, nil
        result.additional_selectors = val.flatten
      }
    ;
  element_name
    : IDENT { result = Selectors::Type.new val.first, nil }
    | STAR  { result = Selectors::Universal.new val.first, nil }
    ;
  hcap
    : hash
    | class
    | attrib
    | pseudo
    | hash hcap   { result = val.flatten }
    | class hcap  { result = val.flatten }
    | attrib hcap { result = val.flatten }
    | pseudo hcap { result = val.flatten }
    ;
  hash
    : HASH { result = Selectors::Id.new val.first.sub(/^#/, '') }
  class
    : '.' IDENT { result = Selectors::Class.new val.last }
    ;
  attrib
    : LSQUARE IDENT EQUAL IDENT RSQUARE {
        result =
          Selectors::Attribute.new val[1], val[3], Selectors::Attribute::EQUALS
      }
    | LSQUARE IDENT EQUAL STRING RSQUARE {
        result = Selectors::Attribute.new(
          val[1],
          strip_string(val[3]),
          Selectors::Attribute::EQUALS
        )
      }
    | LSQUARE IDENT INCLUDES STRING RSQUARE {
        result = Selectors::Attribute.new(
          val[1],
          strip_string(val[3]),
          Selectors::Attribute::INCLUDES
        )
      }
    | LSQUARE IDENT INCLUDES IDENT RSQUARE {
        result =
        Selectors::Attribute.new val[1], val[3], Selectors::Attribute::INCLUDES
      }
    | LSQUARE IDENT DASHMATCH IDENT RSQUARE {
        result =
        Selectors::Attribute.new val[1], val[3], Selectors::Attribute::DASHMATCH
      }
    | LSQUARE IDENT DASHMATCH STRING RSQUARE {
        result = Selectors::Attribute.new(
          val[1],
          strip_string(val[3]),
          Selectors::Attribute::DASHMATCH
        )
      }
    | LSQUARE IDENT RSQUARE {
        result =
          Selectors::Attribute.new val[1], nil, Selectors::Attribute::SET
      }
    ;
  pseudo
    : ':' IDENT { result = Selectors::PseudoClass.new val[1], nil }
    | ':' FUNCTION RPAREN { result = Selectors::PseudoClass.new val[1], nil }
    | ':' FUNCTION IDENT RPAREN
      {
        result = Selectors::PseudoClass.new val[1], val[2]
      }
    ;
  declarations
    : declaration declarations
    | declaration
    ;
  declaration
    : property ':' expr prio SEMI
      { @document.property val.first, Array(val[2]), val[3] }
    | property ':' S expr prio SEMI
      { @document.property val.first, Array(val[3]), val[4] }
    ;
  prio
    : IMPORTANT_SYM { result = true }
    |               { result = false }
    ;
  property
    : IDENT
    ;
  operator
    : COMMA
    | SLASH
    ;
  expr
    : term operator expr {
        result = [val.first, val.last].flatten
        Array(val.last).first.operator = val[1]
      }
    | term expr { result = val.flatten }
    | term
    ;
  term
    : ident
    | numeric
    | string
    | uri
    | hexcolor
    | function
    ;
  function
    : function S { result = val.first }
    | FUNCTION expr RPAREN {
        name = val.first.sub(/\(/, '')
        if name == 'rgb'
          result = Terms::Rgb.new(*Array(val[1]))
        else
          result = Terms::Function.new val.first.sub(/\(/, ''), Array(val[1])
        end
      }
    ;
  hexcolor
    : hexcolor S { result = val.first }
    | HASH { result = Terms::Hash.new val.first.sub(/^#/, '') }
    ;
  uri
    : uri S { result = val.first }
    | URI { result = Terms::URI.new strip_uri val.first }
  string
    : string S { result = val.first }
    | STRING { result = Terms::String.new strip_string val.first }
    ;
  numeric
    : unary_operator numeric {
        result = val[1]
        val[1].unary_operator = val.first
      }
    | NUMBER {
        result = Terms::Number.new numeric val.first
      }
    | PERCENTAGE {
        result = Terms::Number.new numeric(val.first), nil, '%'
      }
    | LENGTH {
        unit    = val.first.gsub(/[\s\d.]/, '')
        result = Terms::Number.new numeric(val.first), nil, unit
      }
    | EMS {
        result = Terms::Number.new numeric(val.first), nil, 'em'
      }
    | EXS {
        result = Terms::Number.new numeric(val.first), nil, 'ex'
      }
    | ANGLE {
        unit    = val.first.gsub(/[\s\d.]/, '')
        result = Terms::Number.new numeric(val.first), nil, unit
      }
    | TIME {
        unit    = val.first.gsub(/[\s\d.]/, '')
        result = Terms::Number.new numeric(val.first), nil, unit
      }
    | FREQ {
        unit    = val.first.gsub(/[\s\d.]/, '')
        result = Terms::Number.new numeric(val.first), nil, unit
      }
    ;
  unary_operator
    : MINUS { result = :minus }
    | PLUS  { result = :plus }
    ;
  ident
    : ident S { result = val.first }
    | IDENT { result = Terms::Ident.new val.first }
    ;

---- inner

def numeric thing
  thing = thing.gsub(/[^\d.]/, '')
  Integer(thing) rescue Float(thing)
end

def strip_uri uri
  strip_string uri.sub(/^url\(/, '').sub(/\)$/, '')
end

def strip_string s
  s.sub(/^["']/, '').sub(/["']$/, '')
end
