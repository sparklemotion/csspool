module CSSPool
module CSS
class Tokenizer < Parser

macro
  nl        \n|\r\n|\r|\f
  w         [\s]*
  nonascii  [^\0-\177]
  num       ([0-9]*\.[0-9]+|[0-9]+)
  unicode   \\[0-9A-Fa-f]{1,6}(\r\n|[\s])?

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

rule

# [:state]  pattern  [actions]

            url\({w}{string}{w}\) { [:URI, st(text)] }
            url\({w}([!#\$%&*-~]|{nonascii}|{escape})*{w}\) { [:URI, st(text)] }
            U\+[0-9a-fA-F?]{1,6}(-[0-9a-fA-F]{1,6})?  {[:UNICODE_RANGE, st(text)] }
            {w}{comment}{w}  { next_token }

            {func}\(\s*      { [:FUNCTION, st(text)] }
            {w}@import{w}    { [:IMPORT_SYM, st(text)] }
            {w}@page{w}      { [:PAGE_SYM, st(text)] }
            {w}@charset{w}   { [:CHARSET_SYM, st(text)] }
            {w}@media{w}     { [:MEDIA_SYM, st(text)] }
            {w}!({w}|{w}{comment}{w})important{w}  { [:IMPORTANT_SYM, st(text)] }
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
            \[{w}            { [:LSQUARE, st(text)] }
            {w}\]            { [:RSQUARE, st(text)] }
            {w}\+{w}         { [:PLUS, st(text)] }
            {w}\{{w}         { [:LBRACE, st(text)] }
            {w}\}{w}         { [:RBRACE, st(text)] }
            {w}>{w}          { [:GREATER, st(text)] }
            {w},{w}          { [:COMMA, st(',')] }
            {w};{w}          { [:SEMI, st(';')] }
            \*               { [:STAR, st(text)] }
            {w}~{w}          { [:TILDE, st(text)] }
            \:not\({w}       { [:NOT, st(text)]  }
            {w}{num}em{w}    { [:EMS, st(text)] }
            {w}{num}ex{w}    { [:EXS, st(text)] }

            {w}{num}(px|cm|mm|in|pt|pc){w}    { [:LENGTH, st(text)] }
            {w}{num}(deg|rad|grad){w} { [:ANGLE, st(text)] }
            {w}{num}(ms|s){w} { [:TIME, st(text)] }
            {w}{num}[k]?hz{w} { [:FREQ, st(text)] }

            {w}{num}%{w}     { [:PERCENTAGE, st(text)] }
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
