require 'crocodile/visitable'
require 'crocodile/node'
require 'crocodile/selectors'
require 'crocodile/terms'
require 'crocodile/selector'
require 'crocodile/sac'
require 'crocodile/lib_croco'
require 'crocodile/version'
require 'crocodile/css'
require 'crocodile/visitors'
require 'crocodile/collection'
require 'crocodile/nokogiri'

module Crocodile
  def self.CSS doc
    Crocodile::CSS::Document.parse doc
  end
end
