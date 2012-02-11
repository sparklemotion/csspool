# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "csspool/version"

Gem::Specification.new do |s|
  s.name        = "csspool"
  s.version     = Csspool::VERSION
  s.authors     = ['Aaron Patterson', 'John Barnette']
  s.email       = ['aaronp@rubyforge.org', 'jbarnette@rubyforge.org']
  s.homepage    = "http://csspool.rubyforge.org/"
  s.summary     = %q{CSSPool is a CSS parser.}
  s.description = %q{CSSPool is a CSS parser. CSSPool provides a SAC interface for parsing CSS as well as a document oriented interface for parsing CSS.}

  s.rubyforge_project = "csspool"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.extra_rdoc_files  =  Dir.glob('*.rdoc')
  s.require_paths = ["lib"]
  # s.readme_file   = 'README.rdoc'
  # s.history_file  = 'CHANGELOG.rdoc'
  
  s.add_development_dependency "bundler"
  s.add_development_dependency "rake"
  s.add_development_dependency "racc"
  s.add_development_dependency "rexical"
  # s.add_development_dependency "rdoc"
end
