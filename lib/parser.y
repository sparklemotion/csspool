class CSS::SAC

token IDENT S STRING IDENT COMMA URI CDO CDC IMPORT_SYM

rule
  stylesheet
    : s_cdo_cdc_0toN import_0toN
    ;
  import
    : IMPORT_SYM s_0toN string_or_uri s_0toN medium_0toN ';' s_0toN {
        p val
      }
    ;
  medium
    : IDENT s_0toN
    |
    ;
  import_0toN
    : import s_cdo_cdc_0toN import_0toN
    |
    ;
  medium_0toN
    : medium COMMA s_0toN medium_0toN { result = [val.first, val.last].flatten }
    | medium
    |
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
