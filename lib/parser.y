class CSS::SAC::GeneratedParser

token FUNCTION INCLUDES DASHMATCH LBRACE HASH PLUS GREATER IDENT S STRING IDENT
token COMMA URI CDO CDC NUMBER PERCENTAGE LENGTH EMS EXS ANGLE TIME FREQ
token IMPORTANT_SYM IMPORT_SYM MEDIA_SYM PAGE_SYM CHARSET_SYM

rule
  stylesheet
    : s_cdo_cdc_0toN CHARSET_SYM STRING ';' import_0toN ruleset_media_page_0toN
    | s_cdo_cdc_0toN import_0toN ruleset_media_page_0toN
    ;
  ruleset_media_page_0toN
    : ruleset s_cdo_cdc_0toN ruleset_media_page_0toN
    | media s_cdo_cdc_0toN ruleset_media_page_0toN
    | page s_cdo_cdc_0toN ruleset_media_page_0toN
    | ruleset s_cdo_cdc_0toN
    | media s_cdo_cdc_0toN
    | page s_cdo_cdc_0toN
    |
    ;
  import
    : IMPORT_SYM s_0toN string_or_uri s_0toN medium_0toN ';' s_0toN {
        self.document_handler.import_style(val[2], val[4])
      }
    ;
  ignorable_at
    : '@' IDENT s_0toN string_or_uri s_0toN medium_0toN ';' s_0toN {
        self.document_handler.ignorable_at_rule(val[1])
      }
    ;
  import_0toN
    : import s_cdo_cdc_0toN import_0toN
    : ignorable_at s_cdo_cdc_0toN import_0toN
    |
    ;
  media
    : MEDIA_SYM s_0toN medium_rollup LBRACE s_0toN ruleset_0toN '}' s_0toN {
        self.document_handler.end_media(val[2])
      }
    ;
  medium_rollup
    : medium_1toN { self.document_handler.start_media(val.first) }
    ;
  medium
    : IDENT s_0toN
    ;
  medium_0toN
    : medium_1toN
    |
    ;
  medium_1toN
    : medium COMMA s_0toN medium_1toN { result = [val.first, val.last].flatten }
    | medium { result = [val.first] }
    ;
  page
    : PAGE_SYM s_0toN pseudo_page s_0toN LBRACE s_0toN declaration_1toN
      '}' s_0toN
    | PAGE_SYM s_0toN s_0toN LBRACE s_0toN declaration_1toN '}' s_0toN
    ;
  pseudo_page
    : ':' IDENT
    ;
  operator
    : '/' s_0toN
    | COMMA s_0toN
    |
    ;
  combinator
    : PLUS s_0toN
    | GREATER s_0toN
    | S
    ;
  unary_operator
    : '-' | PLUS
    ;
  property
    : IDENT s_0toN
    ;
  ruleset
    : selector_1toN LBRACE s_0toN declaration_1toN '}' s_0toN {
        self.document_handler.end_selector(val.first)
      }
    ;
  ruleset_0toN
    : ruleset ruleset_0toN
    | ruleset
    |
    ;
  selector
    : simple_selector_1toN { self.document_handler.start_selector(val.first) }
    ;
  selector_1toN
    : selector COMMA s_0toN selector_1toN
    | selector
    ;
  simple_selector
    : element_name hcap_0toN
    | hcap_1toN
    ;
  simple_selector_1toN
    : simple_selector combinator simple_selector_1toN {
        result = [val.first, val.last].flatten
      }
    | simple_selector { result = [val.first] }
    ;
  class
    : '.' IDENT
    ;
  element_name
    : IDENT | '*'
    ;
  attrib
    : '[' s_0toN IDENT s_0toN attrib_val_0or1 ']'
    ;
  pseudo
    : ':' FUNCTION s_0toN IDENT s_0toN ')'
    | ':' FUNCTION s_0toN s_0toN ')'
    | ':' IDENT
    ;
  declaration
    : property ':' s_0toN expr prio_0or1 {
        self.document_handler.property(val.first, val[3], !val[4].nil?)
      }
    |
    ;
  declaration_1toN
    : declaration ';' s_0toN declaration_1toN
    | declaration
    ;
  prio
    : IMPORTANT_SYM s_0toN
    ;
  prio_0or1
    : prio
    |
    ;
  expr
    : term operator expr { result = [val.first, val.last].flatten }
    | term { result = [val.first] }
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
  function
    : FUNCTION s_0toN expr ')' s_0toN
    ;
  hexcolor
    : HASH s_0toN
    ;
  hcap_0toN
    : hcap_1toN
    |
    ;
  hcap_1toN
    : HASH hcap_1toN
    | class hcap_1toN
    | attrib hcap_1toN
    | pseudo hcap_1toN
    | HASH
    | class
    | attrib
    | pseudo
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
  string_or_uri
    : STRING
    | URI
    ;
  s_cdo_cdc_0toN
    : S s_cdo_cdc_0toN
    | CDO s_cdo_cdc_0toN
    | CDC s_cdo_cdc_0toN
    | S
    | CDO
    | CDC
    |
    ;
  s_0toN
    : S s_0toN
    |
    ;
end
