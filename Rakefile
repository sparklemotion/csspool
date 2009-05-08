# -*- ruby -*-

require 'rubygems'
require 'hoe'
require './lib/crocodile/version.rb'
gem 'rake-compiler', '>= 0.4.1'
require "rake/extensiontask"

HOE = Hoe.new('crocodile', Crocodile::VERSION) do |p|
  p.developer('Aaron Patterson', 'aaronp@rubyforge.org')
end

Rake::ExtensionTask.new("crocodile", HOE.spec) do |ext|
  ext.lib_dir = "lib/crocodile"
end

Rake::Task[:test].prerequisites << :compile
# vim: syntax=Ruby
