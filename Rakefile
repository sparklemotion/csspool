# -*- ruby -*-

require "bundler/gem_tasks"
require "rake/testtask"

GENERATED_TOKENIZER = "lib/csspool/css/tokenizer.rb"
GENERATED_PARSER    = "lib/csspool/css/parser.rb"

Rake::TestTask.new do |test|
  test.pattern = 'test/**/test_*.rb'
  test.libs << 'test'
end

[:build, :install, :release, :test].each do |task_name|
  Rake::Task[task_name].prerequisites << :compile
end

task :compile => [GENERATED_TOKENIZER, GENERATED_PARSER]

file GENERATED_TOKENIZER => "lib/csspool/css/tokenizer.rex" do |t|
  begin
    sh "bundle exec rex -i --independent -o #{t.name} #{t.prerequisites.first}"
  rescue Exception => e
    abort e.message
  end
end

file GENERATED_PARSER => "lib/csspool/css/parser.y" do |t|
  begin
    racc = "bundle exec racc"
    #sh "#{racc} -l -o #{t.name} #{t.prerequisites.first}"
    sh "#{racc} -o #{t.name} #{t.prerequisites.first}"
  rescue Exception => e
    abort e.message
  end
end

# vim: syntax=Ruby
