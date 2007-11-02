require 'rubygems'
require 'erb'
require 'hoe'

$LOAD_PATH.unshift File.join(File.dirname(__FILE__), "lib")

GENERATED_PARSER = "lib/css/sac/generated_parser.rb"
GENERATED_PROPERTY_PARSER = "lib/css/sac/generated_property_parser.rb"

Hoe.new('csspool', '0.0.1') do |p|
  p.rubyforge_name  = 'csspool'
  p.author          = 'Aaron Patterson'
  p.email           = 'aaronp@rubyforge.org'
  p.summary         = "Parses CSS"
  p.description     = p.paragraphs_of('README.txt', 3).join("\n\n")
  p.url             = p.paragraphs_of('README.txt', 1).first.strip
  p.changes         = p.paragraphs_of('CHANGELOG.txt', 0..2).join("\n\n")
  p.clean_globs     = [GENERATED_PARSER]
end

class Array
  def permutations
    return [self] if size < 2
    perm = []
    each { |e| (self - [e]).permutations.each { |p| perm << ([e] + p) } }
    perm
  end

  def permute_all_combinations
    list = []
    permutations.each do |perm|
      while perm.length > 0
        list << perm.dup
        perm.shift
      end
    end
    list.uniq.sort_by { |x| x.length }.reverse
  end
end

file GENERATED_PARSER => "lib/parser.y" do |t|
  sh "racc -o #{t.name} #{t.prerequisites.first}"
end

file GENERATED_PROPERTY_PARSER => "lib/property_parser.y.erb" do |t|
  template = ERB.new(File.open(t.prerequisites.first, 'rb') { |x| x.read })
  File.open("lib/property_parser.y", 'wb') { |f|
    f.write template.result(binding)
  }
  sh "racc -o #{t.name} lib/property_parser.y"
end

task :parser => [GENERATED_PARSER, GENERATED_PROPERTY_PARSER]

# make sure the parser's up-to-date when we test
Rake::Task[:test].prerequisites << :parser
