class CSSPool::CSS::Parser

token CHARSET_SYM IMPORT_SYM STRING SEMI

rule
  document
    : { @document.start_document }
      stylesheet
      { @document.end_document }
    ;
  stylesheet
    : charset import
    ;
  charset
    : CHARSET_SYM STRING SEMI { @document.charset val[1][1..-2] }
    |
    ;
  import
    : IMPORT_SYM STRING
    |
    ;
