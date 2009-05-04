module Crocodile
  class Selector < Crocodile::Node
    attr_accessor :simple_selectors
    def initialize simple_selectors = [], parse_location = {}
      @simple_selectors = simple_selectors
      @parse_location   = parse_location
    end
  end
end
