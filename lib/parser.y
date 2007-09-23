class CSS::SAC

token FUNCTION INCLUDES DASHMATCH LBRACE HASH PLUS GREATER IDENT S STRING IDENT COMMA URI CDO CDC IMPORT_SYM

rule
  stylesheet
    : s_cdo_cdc_0toN import_0toN ruleset
    ;
  import
    : IMPORT_SYM s_0toN string_or_uri s_0toN medium_0toN ';' s_0toN {
        self.document_handler.import_style(val[2], val[4])
      }
    ;
  medium
    : IDENT s_0toN
    ;
  /*
    ruleset
      : selector [ COMMA S* selector ]*
        LBRACE S* declaration [ ';' S* declaration ]* '}' S*
      ;
  */
  ruleset
    : selector_1toN LBRACE s_0toN '}' s_0toN
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
