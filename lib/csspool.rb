require 'csspool/node'
require 'csspool/selectors'
require 'csspool/terms'
require 'csspool/selector'
old = $-w
$-w = false
require 'csspool/css/parser'
$-w = old
require 'csspool/css/tokenizer'
require 'csspool/sac'
require 'csspool/css'
require 'csspool/visitors'
require 'csspool/collection'

module CSSPool
  VERSION = "4.0.3"

  def self.CSS doc
    CSSPool::CSS::Document.parse doc
  end
end
