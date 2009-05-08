module Crocodile
  class SimpleSelector < Crocodile::Node
    NO_SELECTOR_TYPE    = 0
    UNIVERSAL_SELECTOR  = 1
    TYPE_SELECTOR       = 1 << 1

    NO_COMBINATOR       = 0
    DESCENDENT          = 1
    PRECEDED_BY         = 2
    CHILD               = 3

    attr_accessor :name
    attr_accessor :type
    attr_accessor :parse_location
    def initialize name, type = NO_SELECTOR_TYPE, combinator = nil
      @name       = name
      @type       = type
      @combinator = combinator
      @parse_location = nil
    end
  end
end
