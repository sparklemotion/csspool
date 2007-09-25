class CSS::SAC

token FUNCTION INCLUDES DASHMATCH LBRACE HASH PLUS GREATER IDENT S STRING IDENT
token COMMA URI CDO CDC NUMBER PERCENTAGE LENGTH EMS EXS ANGLE TIME FREQ
token IMPORTANT_SYM IMPORT_SYM MEDIA_SYM PAGE_SYM

rule
/*
stylesheet
  : [ CHARSET_SYM STRING ';' ]?
    [S|CDO|CDC]* [ import [S|CDO|CDC]* ]*
    [ [ ruleset | media | page ] [S|CDO|CDC]* ]*
  ;
*/
  stylesheet
    : s_cdo_cdc_0toN import_0toN page
    ;
  import
    : IMPORT_SYM s_0toN string_or_uri s_0toN medium_0toN ';' s_0toN {
        self.document_handler.import_style(val[2], val[4])
      }
    ;
  media
    : MEDIA_SYM s_0toN medium_1toN LBRACE s_0toN ruleset_0toN '}' s_0toN
    ;
  medium
    : IDENT s_0toN
    ;
  page
    : PAGE_SYM s_0toN pseudo_page s_0toN LBRACE s_0toN declaration_1toN
      '}' s_0toN
    | PAGE_SYM s_0toN s_0toN LBRACE s_0toN declaration_1toN '}' s_0toN
    ;
  pseudo_page
    : ':' IDENT
    ;
  ruleset_0toN
    : ruleset ruleset_0toN
    | ruleset
    |
    ;
  ruleset
    : selector_1toN LBRACE s_0toN declaration_1toN '}' s_0toN
    ;
  declaration_1toN
    : declaration ';' s_0toN declaration_1toN
    | declaration
    ;
  declaration
    : property ':' s_0toN expr prio
    | property ':' s_0toN expr { p val }
    |
    ;
  prio
    : IMPORTANT_SYM s_0toN
    ;
  property
    : IDENT s_0toN
    ;
  expr
    : operator expr
    | term
    ;
  operator
    : '/' s_0toN
    | COMMA s_0toN
    |
    ;
  term
    : unary_operator num_or_length
    | num_or_length
    | STRING s_0toN
    | IDENT s_0toN
    | URI s_0toN
    | hexcolor
    | function
    ;
  unary_operator
    : '-' | PLUS
    ;
  num_or_length
    : NUMBER s_0toN
    | PERCENTAGE s_0toN
    | LENGTH s_0toN
    | EMS s_0toN
    | EXS s_0toN
    | ANGLE s_0toN
    | TIME s_0toN
    | FREQ s_0toN
    ;
  hexcolor
    : HASH s_0toN
    ;
  function
    : FUNCTION s_0toN expr ')' s_0toN
    ;
  selector_1toN
    : selector COMMA s_0toN selector_1toN
    | selector
    ;
  selector
    : simple_selector_1toN
    ;
  simple_selector
    : element_name hcap_0toN
    | hcap_1toN
    ;
  simple_selector_1toN
    : simple_selector combinator simple_selector_1toN
    | simple_selector
    ;
  hcap_0toN
    : hcap_1toN
    |
    ;
  hcap_1toN
    : HASH hcap_0toN
    | class hcap_0toN
    | attrib hcap_0toN
    | pseudo hcap_0toN
    | HASH
    | class
    | attrib
    | pseudo
    ;
  pseudo
    : ':' FUNCTION s_0toN IDENT s_0toN ')'
    | ':' FUNCTION s_0toN s_0toN ')'
    | ':' IDENT
    ;
  attrib
    : '[' s_0toN IDENT s_0toN attrib_val_0or1 ']'
    ;
  attrib_val_0or1
    : eql_incl_dash s_0toN IDENT s_0toN
    | eql_incl_dash s_0toN STRING s_0toN
    |
    ;
  eql_incl_dash
    : '='
    | INCLUDES
    | DASHMATCH
    ;
  combinator
    : PLUS s_0toN
    | GREATER s_0toN
    | S
    ;
  class
    : '.' IDENT
    ;
  element_name
    : IDENT | '*'
    ;
  import_0toN
    : import s_cdo_cdc_0toN import_0toN
    |
    ;
  medium_0toN
    : medium_1toN
    |
    ;
  medium_1toN
    : medium COMMA s_0toN medium_1toN { result = [val.first, val.last].flatten }
    | medium { result = [val.first] }
    ;
  string_or_uri
    : STRING
    | URI
    ;
  s_cdo_cdc_0toN
    : s_0toN cdo_0toN cdc_0toN s_cdo_cdc_0toN
    |
    ;
  cdo_0toN
    : CDO cdo_0toN
    |
    ;
  cdc_0toN
    : CDC cdc_0toN
    |
    ;
  s_0toN
    : S s_0toN
    |
    ;
end
