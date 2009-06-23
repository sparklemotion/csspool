module Crocodile
  class Selector < Crocodile::Node
    attr_accessor :simple_selectors
    def initialize simple_selectors = [], parse_location = {}
      @simple_selectors = simple_selectors
      @parse_location   = parse_location
    end

    def specificity
      a = b = c = 0
      simple_selectors.each do |s|
        c += 1
        s.additional_selectors.each do |additional_selector|
          if Selectors::Id === additional_selector
            a += 1
          else
            b += 1
          end
        end
      end
      a * 1000000 + b * 1000 + c
    end
  end
end
