module CSSPool
module CSS
class Tokenizer < Parser

macro
  nl        (\n|\r\n|\r|\f)
  w         [\s]*
  nonascii  [^\0-\177]
  num       ([0-9]*\.[0-9]+|[0-9]+)
  length    {num}(px|cm|mm|in|pt|pc|mozmm|em|ex|ch|rem|vh|vw|vmin|vmax)
  percentage {num}%
  unicode   \\[0-9A-Fa-f]{1,6}(\r\n|[\s])?
  nth       ([\+\-]?[0-9]*n({w}[\+\-]{w}[0-9]+)?|[\+\-]?[0-9]+|odd|even)
  vendorprefix \-[A-Za-z]+\-

  escape    {unicode}|\\[^\n\r\f0-9A-Fa-f]
  nmchar    [_A-Za-z0-9-]|{nonascii}|{escape}
  nmstart   [_A-Za-z]|{nonascii}|{escape}
  ident     [-@]?({nmstart})({nmchar})*
  func      [-@]?({nmstart})({nmchar}|[.])*
  name      ({nmchar})+
  string1   "([^\n\r\f\\"]|\\{nl}|{nonascii}|{escape})*"
  string2   '([^\n\r\f\\']|\\{nl}|{nonascii}|{escape})*'
  string    ({string1}|{string2})
  invalid1  "([^\n\r\f\\"]|\\{nl}|{nonascii}|{escape})*
  invalid2  '([^\n\r\f\\']|\\{nl}|{nonascii}|{escape})*
  invalid   ({invalid1}|{invalid2})
  comment   \/\*(.|{w})*?\*\/
  variablename \-\-{name}

rule

# [:state]  pattern  [actions]

# "Logical queries", such as those used by @supports and @media, include keywords that match our IDENT pattern.
# Including these as lexical words makes their use anywhere else (even inside other words!) not possible.
# So we define a new state, and list the things that can occur.
:LOGICQUERY url\({w}{string}{w}\) { [:URI, st(text)] }
:LOGICQUERY url\({w}([!#\$%&*-~]|{nonascii}|{escape})*{w}\) { [:URI, st(text)] }
:LOGICQUERY {func}\(\s*      { [:FUNCTION, st(text)] }
:LOGICQUERY {w}(and|only|not|or)[\s]+ { [text.upcase.strip.intern, st(text)] }
:LOGICQUERY {w}{num}(dpi|dpcm)     { [:RESOLUTION, st(text)]}
:LOGICQUERY {w}{length}{w}   { [:LENGTH, st(text)] }
:LOGICQUERY {w}{num}(deg|rad|grad){w} { [:ANGLE, st(text)] }
:LOGICQUERY {w}{num}(ms|s){w} { [:TIME, st(text)] }
:LOGICQUERY {w}{num}[k]?hz{w} { [:FREQ, st(text)] }
:LOGICQUERY {w}{percentage}{w} { [:PERCENTAGE, st(text)] }
:LOGICQUERY {w}{num}{w}      { [:NUMBER, st(text)] }
:LOGICQUERY {ident}          { [:IDENT, st(text)] }
:LOGICQUERY {w},{w}          { [:COMMA, st(',')] }
:LOGICQUERY {w}\)            { [:RPAREN, st(text)] }
:LOGICQUERY {w}\(            { [:LPAREN, st(text)] }
:LOGICQUERY \:               { [:COLON, st(text)] }
:LOGICQUERY {w}!({w}|{w}{comment}{w})important{w}  { [:IMPORTANT_SYM, st(text)] }
# this marks the end of our logical query
:LOGICQUERY {w}\{{w}         { @state = nil; [:LBRACE, st(text)] }
:LOGICQUERY [\s]+            { [:S, st(text)] }

            url\({w}{string}{w}\) { [:URI, st(text)] }
            url\({w}([!#\$%&*-~]|{nonascii}|{escape})*{w}\) { [:URI, st(text)] }
            U\+[0-9a-fA-F?]{1,6}(-[0-9a-fA-F]{1,6})?  {[:UNICODE_RANGE, st(text)] }
            {w}{comment}{w}  { next_token }

            # this one takes a selector as a parameter
            not\({w}            { [:NOT_PSEUDO_CLASS, st(text)] }

            # this one takes an "nth" value
            (nth\-child|nth\-last\-child|nth\-of\-type|nth\-last\-of\-type)\({w}{nth}{w}\) { [:NTH_PSEUDO_CLASS, st(text)] }

            # this one takes a comma-separated list of simple selectors as a parameter
            ({vendorprefix})?(matches|any)\(\s* { [:MATCHES_PSEUDO_CLASS, st(text)] }

            # functions that can take an unquoted string parameter
            (domain|url\-prefix)\({w}{string}{w}\) { [:FUNCTION_NO_QUOTE, st(text)] }
            (domain|url\-prefix)\({w}([!#\$%&*-~]|{nonascii}|{escape})*{w}\) { [:FUNCTION_NO_QUOTE, st(text)] }

            # mozilla-specific pseudo-elements that can be used with one or two colons and can have multiple parameters
            (\-moz\-non\-element|\-moz\-anonymous\-block|\-moz\-anonymous\-positioned\-block|\-moz\-mathml\-anonymous\-block|\-moz\-xul\-anonymous\-block|\-moz\-hframeset\-border|\-moz\-vframeset\-border|\-moz\-line\-frame|\-moz\-button\-content|\-moz\-buttonlabel|\-moz\-cell\-content|\-moz\-dropdown\-list|\-moz\-fieldset\-content|\-moz\-frameset\-blank|\-moz\-display\-comboboxcontrol\-frame|\-moz\-html\-canvas\-content|\-moz\-inline\-table|\-moz\-table|\-moz\-table\-cell|\-moz\-table\-column\-group|\-moz\-table\-column|\-moz\-table\-outer|\-moz\-table\-row\-group|\-moz\-table\-row|\-moz\-canvas|\-moz\-pagebreak|\-moz\-page|\-moz\-pagecontent|\-moz\-page\-sequence|\-moz\-scrolled\-content|\-moz\-scrolled\-canvas|\-moz\-scrolled\-page\-sequence|\-moz\-column\-content|\-moz\-viewport|\-moz\-viewport\-scroll|\-moz\-anonymous\-flex\-item|\-moz\-tree\-column|\-moz\-tree\-row|\-moz\-tree\-separator|\-moz\-tree\-cell|\-moz\-tree\-indentation|\-moz\-tree\-line|\-moz\-tree\-twisty|\-moz\-tree\-image|\-moz\-tree\-cell\-text|\-moz\-tree\-checkbox|\-moz\-tree\-progressmeter|\-moz\-tree\-drop\-feedback|\-moz\-svg\-outer\-svg\-anon\-child|\-moz\-svg\-foreign\-content|\-moz\-svg\-text)\( { [:MOZ_PSEUDO_ELEMENT, st(text)] }

            {w}@media{w}     { @state = :LOGICQUERY; [:MEDIA_SYM, st(text)] }
            {w}@supports{w}  { @state = :LOGICQUERY; [:SUPPORTS_SYM, st(text)] }

            calc\(\s*        { [:CALC_SYM, st(text)] }
            {func}\(\s*      { [:FUNCTION, st(text)] }

            {w}@import{w}    { [:IMPORT_SYM, st(text)] }
            {w}@page{w}      { [:PAGE_SYM, st(text)] }
            {w}@charset{w}   { [:CHARSET_SYM, st(text)] }
            {w}@({vendorprefix})?document{w} { [:DOCUMENT_QUERY_SYM, st(text)] }
            {w}@namespace{w} { [:NAMESPACE_SYM, st(text)] }
            {w}@({vendorprefix})?keyframes{w} { [:KEYFRAMES_SYM, st(text)] }
            {func}\(\s*      { [:FUNCTION, st(text)] }
            {w}!({w}|{w}{comment}{w})important{w}  { [:IMPORTANT_SYM, st(text)] }
            {variablename}   { [:VARIABLE_NAME, st(text)] }
            {ident}          { [:IDENT, st(text)] }
            \#{name}         { [:HASH, st(text)] }
            {w}~={w}         { [:INCLUDES, st(text)] }
            {w}\|={w}        { [:DASHMATCH, st(text)] }
            {w}\^={w}        { [:PREFIXMATCH, st(text)] }
            {w}\$={w}        { [:SUFFIXMATCH, st(text)] }
            {w}\*={w}        { [:SUBSTRINGMATCH, st(text)] }
            {w}!={w}         { [:NOT_EQUAL, st(text)] }
            {w}={w}          { [:EQUAL, st(text)] }
            {w}\)            { [:RPAREN, st(text)] }
            {w}\(            { [:LPAREN, st(text)] }
            \[{w}            { [:LSQUARE, st(text)] }
            {w}\]            { [:RSQUARE, st(text)] }
            {w}\+{w}         { [:PLUS, st(text)] }
            {w}\{{w}         { [:LBRACE, st(text)] }
            {w}\}{w}         { [:RBRACE, st(text)] }
            {w}>{w}          { [:GREATER, st(text)] }
            {w},{w}          { [:COMMA, st(',')] }
            {w};{w}          { [:SEMI, st(';')] }
            \:               { [:COLON, st(text)] }
            \*               { [:STAR, st(text)] }
            {w}~{w}          { [:TILDE, st(text)] }

            {w}{length}{w}   { [:LENGTH, st(text)] }
            {w}{num}(deg|rad|grad){w} { [:ANGLE, st(text)] }
            {w}{num}(ms|s){w} { [:TIME, st(text)] }
            {w}{num}[k]?hz{w} { [:FREQ, st(text)] }

            {w}{percentage}{w} { [:PERCENTAGE, st(text)] }
            {w}{num}{w}      { [:NUMBER, st(text)] }
            {w}\/\/{w}       { [:DOUBLESLASH, st(text)] }
            {w}\/{w}         { [:SLASH, st('/')] }
            <!--             { [:CDO, st(text)] }
            -->              { [:CDC, st(text)] }
            {w}\-(?!{ident}){w}   { [:MINUS, st(text)] }
            {w}\+{w}         { [:PLUS, st(text)] }


            [\s]+            { [:S, st(text)] }
            {string}         { [:STRING, st(text)] }
            {invalid}        { [:INVALID, st(text)] }
            .                { [st(text), st(text)] }

inner

def st o
  @st ||= Hash.new { |h,k| h[k] = k }
  @st[o]
end

end
end
end

# vim: syntax=lex
