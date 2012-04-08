# -*- ruby -*-

require 'rubygems'
require 'hoe'

GENERATED_TOKENIZER = "lib/csspool/css/tokenizer.rb"
GENERATED_PARSER    = "lib/csspool/css/parser.rb"

Hoe.plugin :git
Hoe.plugin :bundler
Hoe.plugin :gemspec

Hoe.spec('csspool') do
  developer('Aaron Patterson', 'aaronp@rubyforge.org')
  developer('John Barnette', 'jbarnette@rubyforge.org')
  self.readme_file   = 'README.rdoc'
  self.history_file  = 'CHANGELOG.rdoc'
  self.extra_rdoc_files  = FileList['*.rdoc']

  %w{racc rexical hoe-git hoe-gemspec hoe-bundler}.each do |dep|
    self.extra_dev_deps << [dep, '>= 0']
  end
end

[:test, :check_manifest, "gem:spec"].each do |task_name|
  Rake::Task[task_name].prerequisites << :compile
end

task :compile => [GENERATED_TOKENIZER, GENERATED_PARSER]

file GENERATED_TOKENIZER => "lib/csspool/css/tokenizer.rex" do |t|
  begin
    sh "bundle exec rex -i --independent -o #{t.name} #{t.prerequisites.first}"
  rescue
    abort "need rexical, sudo gem install rexical"
  end
end

file GENERATED_PARSER => "lib/csspool/css/parser.y" do |t|
  begin
    racc = 'bundle exec racc'
    #sh "#{racc} -l -o #{t.name} #{t.prerequisites.first}"
    sh "#{racc} -o #{t.name} #{t.prerequisites.first}"
  rescue
    abort "need racc, sudo gem install racc"
  end
end

# vim: syntax=Ruby
