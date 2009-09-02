class CSSPool::CSS::Parser

token CHARSET_SYM IMPORT_SYM STRING SEMI IDENT S COMMA LBRACE RBRACE STAR HASH
token LSQUARE RSQUARE EQUAL INCLUDES DASHMATCH RPAREN FUNCTION GREATER PLUS

rule
  document
    : { @document.start_document }
      stylesheet
      { @document.end_document }
    ;
  stylesheet
    : charset import body
    ;
  charset
    : CHARSET_SYM STRING SEMI { @document.charset val[1][1..-2], {} }
    |
    ;
  import
    : IMPORT_SYM STRING S medium SEMI
      {
        @document.import_style [val[3]].flatten, val[1][1..-2]
      }
    | IMPORT_SYM STRING SEMI { @document.import_style [], val[1][1..-2] }
    |
    ;
  medium
    : medium COMMA IDENT { result = [val.first, val.last] }
    | IDENT
    ;
  body
    : ruleset
    ;
  ruleset
    : start_selector declaration RBRACE { @document.end_selector [val.first] }
    |
    ;
  start_selector
    : selectors LBRACE { @document.start_selector Array(val.first) }
    ;
  selectors
    : selector COMMA selectors
      {
        sel = Selector.new(val.first, {})
        result = [sel, val[2]].flatten
      }
    | selector
      {
        result = Selector.new(val.first, {})
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
    : element_name hcap { result = val.first }
    | element_name
    | hcap              { result = Selectors::Simple.new nil, nil }
    ;
  element_name
    : IDENT { result = Selectors::Type.new val.first, nil }
    | STAR  { result = Selectors::Universal.new val.first, nil }
    ;
  hcap
    : HASH
    | class
    | attrib
    | pseudo
    | HASH hcap
    | class hcap
    | attrib hcap
    | pseudo hcap
    ;
  class
    : '.' IDENT
    ;
  attrib
    : LSQUARE IDENT EQUAL IDENT RSQUARE
    | LSQUARE IDENT EQUAL STRING RSQUARE
    | LSQUARE IDENT INCLUDES STRING RSQUARE
    | LSQUARE IDENT INCLUDES IDENT RSQUARE
    | LSQUARE IDENT DASHMATCH IDENT RSQUARE
    | LSQUARE IDENT DASHMATCH STRING RSQUARE
    | LSQUARE IDENT RSQUARE
    ;
  pseudo
    : ':' IDENT
    | ':' FUNCTION RPAREN
    | ':' FUNCTION IDENT RPAREN
    ;
  declaration
    : property ':' S expr SEMI
      { @document.property val.first, Array(val[3]) }
    |
    ;
  property
    : IDENT
    ;
  expr
    : term expr { result = val }
    | term
    ;
  term
    : term_ident { result = Terms::Ident.new(val.first, nil, {}) }
    ;
  term_ident
    : IDENT S { result = val.first }
    | IDENT
    ;
