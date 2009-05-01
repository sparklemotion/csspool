ENV["ARCHFLAGS"] = "-arch #{`uname -p` =~ /powerpc/ ? 'ppc' : 'i386'}"

require 'mkmf'

$CFLAGS << " -Wall"

$CFLAGS << " #{`croco-0.6-config --cflags`.chomp}"
$libs << " #{`croco-0.6-config --libs`.chomp}"

create_makefile('crocodile/crocodile')
