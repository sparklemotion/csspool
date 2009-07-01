require 'csspool/visitable'
require 'csspool/node'
require 'csspool/selectors'
require 'csspool/terms'
require 'csspool/selector'
require 'csspool/sac'
require 'csspool/lib_croco'
require 'csspool/css'
require 'csspool/visitors'
require 'csspool/collection'

module CSSPool
  VERSION = "2.0.0"

  def self.CSS doc
    CSSPool::CSS::Document.parse doc
  end
end
