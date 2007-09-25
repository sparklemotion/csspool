require 'rubygems'
require 'hoe'

$LOAD_PATH.unshift File.join(File.dirname(__FILE__), "lib")

Hoe.new('csspool', '0.0.1') do |p|
  p.rubyforge_name  = 'csspool'
  p.author          = 'Aaron Patterson'
  p.email           = 'aaronp@rubyforge.org'
  p.summary         = "Parses CSS"
  p.description     = "blah"
  p.url             = "blah"
  p.changes         = "blah"
  #p.description     = p.paragraphs_of('README.txt', 3).join("\n\n")
  #p.url             = p.paragraphs_of('README.txt', 1).first.strip
  #p.changes         = p.paragraphs_of('CHANGELOG.txt', 0..2).join("\n\n")
end

desc "Build the RACC parser"
task :build do
  system("racc lib/parser.y -o lib/css/sac/generated_parser.rb")
end
