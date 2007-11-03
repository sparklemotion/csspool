= CSSpool

  http://csspool.rubyforge.org/

== Description

CSSpool (pronounced "cesspool") is a validating SAC parser for CSS.  The parser
calls methods on a document handler depending on what it has found. CSSPool
currently only supports CSS 2.1.  CSSPool will not yield invalid properties or
selectors.

== Dependencies

Building CSSpool requires:

  - RACC (not just the runtime)
    (http://i.loveruby.net/en/projects/racc)

  - rubygems, hoe, flexmock

== Example

This example prints out all properties from a particular CSS file.

  class DH < CSS::SAC::DocumentHandler
    def start_selector(selectors)
      puts selectors.map { |x| x.to_css }.join(', ')
    end

    def property(name, value, important)
      puts "#{name} #{value.join(', ')} #{important}"
    end
  end
  
  token = CSS::SAC::Parser.new(DH.new)
  token.parse(File.read(ARGV[0]))

See CSS::SAC::DocumentHandler for callbacks to implement.

See SAC[http://www.w3.org/Style/CSS/SAC/] for more information on SAC.

== Authors

* Aaron Patterson[http://tenderlovemaking.com/] <aaronp@rubyforge.com>
* John Barnette

== LICENSE

(The MIT License)

Copyright (c) 2007 Aaron Patterson, John Barnette

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

