require 'rubygems'
require 'hoe'

$LOAD_PATH.unshift File.join(File.dirname(__FILE__), "lib")

GENERATED_PARSER = "lib/css/sac/generated_parser.rb"

Hoe.new('csspool', '0.0.1') do |p|
  p.rubyforge_name  = 'csspool'
  p.author          = 'Aaron Patterson'
  p.email           = 'aaronp@rubyforge.org'
  p.summary         = "Parses CSS"
  p.description     = "blah"
  p.url             = "blah"
  p.changes         = "blah"
  p.clean_globs     = [GENERATED_PARSER]
  #p.description     = p.paragraphs_of('README.txt', 3).join("\n\n")
  #p.url             = p.paragraphs_of('README.txt', 1).first.strip
  #p.changes         = p.paragraphs_of('CHANGELOG.txt', 0..2).join("\n\n")
end

file GENERATED_PARSER => "lib/parser.y" do |t|
  sh "racc -o #{t.name} #{t.prerequisites.first}"
end

# make sure the parser's up-to-date when we test
Rake::Task[:test].prerequisites << GENERATED_PARSER
