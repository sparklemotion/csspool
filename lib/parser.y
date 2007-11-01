class CSS::SAC::GeneratedParser

token FUNCTION INCLUDES DASHMATCH LBRACE HASH PLUS GREATER S STRING IDENT
token COMMA URI CDO CDC NUMBER PERCENTAGE LENGTH EMS EXS ANGLE TIME FREQ
token IMPORTANT_SYM IMPORT_SYM MEDIA_SYM PAGE_SYM CHARSET_SYM DIMENSION

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
        self.document_handler.import_style(val[2], val[4] || [])
      }
    ;
  optional_ignorable_at
    : ignorable_at
    |
    ;
  ignorable_at
    : '@' IDENT s_0toN string_or_uri s_0toN medium_0toN ';' s_0toN {
        self.document_handler.ignorable_at_rule(val[1])
      }
    | '@' IDENT s_0toN error S {
        yyerrok
        self.document_handler.ignorable_at_rule(val[1])
      }
    ;
  import_0toN
    : import s_cdo_cdc_0toN import_0toN
    | ignorable_at s_cdo_cdc_0toN import_0toN
    |
    ;
  media
    : MEDIA_SYM s_0toN medium_rollup s_0toN ruleset_0toN '}' s_0toN {
        self.document_handler.end_media(val[2])
      }
    ;
  medium_rollup
    : medium_1toN LBRACE { self.document_handler.start_media(val.first) }
    | medium_1toN error LBRACE {
        yyerrok
        self.document_handler.start_media(val.first)
        error = ParseException.new("Error near: \"#{val[0]}\"")
        self.error_handler.error(error)
      }
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
    : page_start s_0toN LBRACE s_0toN declaration_0toN '}' s_0toN {
        page_stuff = val.first
        self.document_handler.end_page(page_stuff[0], page_stuff[1])
      }
    ;
  page_start
    : PAGE_SYM s_0toN optional_page optional_pseudo_page {
        result = [val[2], val[3]]
        self.document_handler.start_page(val[2], val[3])
      }
    ;
  optional_page
    : IDENT
    |
    ;
  optional_pseudo_page
    : ':' IDENT { result = val[1] }
    |
    ;
  operator
    : '/' s_0toN
    | COMMA s_0toN
    |
    ;
  combinator
    : PLUS s_0toN { result = :SAC_DIRECT_ADJACENT_SELECTOR }
    | GREATER s_0toN { result = :SAC_CHILD_SELECTOR }
    | S { result = :SAC_DESCENDANT_SELECTOR }
    ;
  unary_operator
    : '-' | PLUS
    ;
  property
    : IDENT s_0toN
    ;
  ruleset
    : selector_1toN s_0toN declaration_0toN '}' s_0toN {
        self.document_handler.end_selector([val.first].flatten.compact)
      }
    ;
  ruleset_0toN
    : ruleset ruleset_0toN
    | ruleset
    |
    ;
  selector
    : simple_selector_1toN { result = val.flatten }
    ;
  selector_1toN
    : selector_list s_0toN LBRACE {
        self.document_handler.start_selector([val.first].flatten.compact)
      }
    | selector error LBRACE {
        yyerrok
        self.document_handler.start_selector([val.first].flatten.compact)
      }
    | selector LBRACE {
        self.document_handler.start_selector([val.first].flatten.compact)
      }
    ;
  selector_list
    : selector COMMA s_0toN selector_list { result = [val[0], val[3]] }
    | selector
    ;
  simple_selector
    : element_name hcap_0toN {
        result =  if val[1].nil?
                    val.first
                  else
                    ConditionalSelector.new(val.first, val[1])
                  end
      }
    | hcap_1toN {
        result = ConditionalSelector.new(nil, val.first)
      }
    ;
  simple_selector_1toN
    : simple_selector combinator simple_selector_1toN {
        result =
          if val[1] == :SAC_DIRECT_ADJACENT_SELECTOR
            SiblingSelector.new(val.first, val[2])
          else
            DescendantSelector.new(val.first, val[2], val[1])
          end
      }
    | simple_selector
    ;
  class
    : '.' IDENT { result = AttributeCondition.class_condition(val[1]) }
    ;
  element_name
    : IDENT { result = ElementSelector.new(val.first) }
    | '*' { result = SimpleSelector.new() }
    ;
  attrib
    : '[' s_0toN IDENT s_0toN attrib_val_0or1 ']' {
        result = AttributeCondition.attribute_condition(val[2], val[4])
      }
    ;
  pseudo
    : ':' FUNCTION s_0toN IDENT s_0toN ')'
    | ':' FUNCTION s_0toN s_0toN ')'
    | ':' IDENT { result = AttributeCondition.pseudo_class_condition(val[1]) }
    ;
  declaration
    : property ':' s_0toN expr prio_0or1 {
        if value = self.property_parser.parse_tokens(
          self.tokenizer.tokenize(val.flatten[0..-2].join(' '))
        )

          value = [value].flatten

          self.document_handler.property(val.first, value, !val[4].nil?)
          result = value
        end
      }
    ;
  declaration_0toN
    : declaration ';' s_0toN declaration_0toN
    | declaration error ';' s_0toN declaration_0toN {
        yyerrok
        error = ParseException.new("Unkown property: \"#{val[1]}\"")
        self.error_handler.error(error)
      }
    | declaration
    | s_0toN ';' s_0toN declaration_0toN
    |
    ;
  prio
    : IMPORTANT_SYM s_0toN
    ;
  prio_0or1
    : prio
    |
    ;
  expr
    : term operator expr { result = val }
    | term
    ;
  term
    : unary_operator num_or_length { result = val }
    | num_or_length { result = val }
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
    : FUNCTION s_0toN expr ')' s_0toN { result = [val[0], val[2], val[3]] }
    | FUNCTION s_0toN expr error ')' s_0toN { yyerrok; result = [val[0], val[2], val[3]] }
    ;
  hexcolor
    : HASH s_0toN
    ;
  hcap_0toN
    : hcap_1toN
    |
    ;
  hcap_1toN
    : attribute_id hcap_1toN {
        result = CombinatorCondition.new(val[0], val[1])
      }
    | class hcap_1toN {
        result = CombinatorCondition.new(val[0], val[1])
      }
    | attrib hcap_1toN {
        result = CombinatorCondition.new(val[0], val[1])
      }
    | pseudo hcap_1toN {
        result = CombinatorCondition.new(val[0], val[1])
      }
    | attribute_id
    | class
    | attrib
    | pseudo
    ;
  attribute_id
    : HASH { result = AttributeCondition.attribute_id(val.first) }
    ;
  attrib_val_0or1
    : eql_incl_dash s_0toN IDENT s_0toN { result = [val.first, val[2]] }
    | eql_incl_dash s_0toN STRING s_0toN { result = [val.first, val[2]] }
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
