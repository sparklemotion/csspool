class CSSPool::CSS::Parser

rule
  document
    : { @document.start_document }
      stylesheet
      { @document.end_document }
    ;
  stylesheet
    : import
    ;

  import
    : IMPORT_SYM STRING
    ;
