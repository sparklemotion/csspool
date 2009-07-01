= CSSPool

* http://csspool.rubyforge.org
* http://github.com/tenderlove/csspool

== DESCRIPTION:

CSSPool is a CSS parser.  CSSPool provides a SAC interface for parsing CSS as
well as a document oriented interface for parsing CSS.

== FEATURES/PROBLEMS:

CSSPool now depends on libcroco[http://www.freespiders.org/projects/libcroco/]
and interfaces with libcroco via FFI.  This means that if libcroco isn't
installed in one of your default library paths, you'll need to tell CSSPool
where to find the libcroco shared library.  This is typically the case for
people using OS X and installing libcroco via macports.

You can tell CSSPool where to find the libcroco shared library in a couple ways.
The first way is to set LD_LIBRARY_PATH to point at the correct directory.  Just
do this:

  $ export LD_LIBRARY_PATH=/opt/local/lib

Then run your script.

The second way is to tell CSSPool specifically where to find the dynamic
library.  To do that, just set the LIBCROCO environment variable.  On OS X,
I would do this:

  $ export LIBCROCO=/opt/local/lib/libcroco-0.6.dylib

Then run my script.

== SYNOPSIS:

  doc = CSSPool.CSS open('/path/to/css.css')
  doc.rule_sets.each do |rs|
    puts rs.to_css
  end

  puts doc.to_css

== REQUIREMENTS:

* libcroco (on OS X do "sudo port install libcroco")

== INSTALL:

* sudo gem install csspool

== LICENSE:

(The MIT License)

Copyright (c) 2009

* {Aaron Patterson}[http://tenderlovemaking.com]

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
