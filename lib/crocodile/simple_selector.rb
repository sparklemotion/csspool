module Crocodile
  class SimpleSelector < Crocodile::Node
    NO_SELECTOR_TYPE    = 0
    UNIVERSAL_SELECTOR  = 1
    TYPE_SELECTOR       = 1 << 1

    attr_accessor :name
    attr_accessor :type
    def initialize name, type = NO_SELECTOR_TYPE, combinator = nil
      @name       = name
      @type       = type
      @combinator = nil
    end
  end
end
