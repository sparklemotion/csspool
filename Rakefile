# -*- ruby -*-

require 'rubygems'
require 'hoe'

GENERATED_TOKENIZER = "lib/csspool/css/tokenizer.rb"

Hoe.spec('csspool') do
  developer('Aaron Patterson', 'aaronp@rubyforge.org')
  developer('John Barnette', 'jbarnette@rubyforge.org')
  self.readme_file   = 'README.rdoc'
  self.history_file  = 'CHANGELOG.rdoc'
  self.extra_rdoc_files  = FileList['*.rdoc']
  self.extra_deps = ['ffi']

  %w{ racc rexical }.each do |dep|
    self.extra_dev_deps << [dep, '>= 0']
  end
end

[:test, :check_manifest].each do |task_name|
  Rake::Task[task_name].prerequisites << GENERATED_TOKENIZER
end

file GENERATED_TOKENIZER => "lib/csspool/css/tokenizer.rex" do |t|
  begin
    sh "rex --independent -o #{t.name} #{t.prerequisites.first}"
  rescue
    abort "need rexical, sudo gem install rexical"
  end
end

# vim: syntax=Ruby
