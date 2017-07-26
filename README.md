**csspool is looking for a maintainer. If you are interested, email jason.barnabe@gmail.com.**

* http://csspool.rubyforge.org
* https://github.com/sparklemotion/csspool

[![Build Status](https://travis-ci.org/sparklemotion/csspool.svg?branch=master)](https://travis-ci.org/sparklemotion/csspool)

CSSPool is a CSS parser.  CSSPool provides a SAC interface for parsing CSS as well as a document oriented interface for parsing CSS.

## Install

`gem install csspool`

## Example

```ruby
doc = CSSPool.CSS open('/path/to/css.css')
doc.rule_sets.each do |rs|
  puts rs.to_css
end

puts doc.to_css
```

## License

(The MIT License)

Copyright (c) 2007-2015

- [Aaron Patterson](http://tenderlovemaking.com)
- [John Barnette](http://www.jbarnette.com/)
- Jason Barnabe

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
