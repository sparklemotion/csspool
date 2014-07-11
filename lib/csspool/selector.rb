module CSSPool
  class Selector < CSSPool::Node
    attr_accessor :simple_selectors
    attr_accessor :parse_location
    attr_accessor :rule_set

    def initialize simple_selectors = [], parse_location = {}
      @simple_selectors = simple_selectors
      @parse_location   = parse_location
      @rule_set         = nil
    end

    def declarations
      @rule_set.declarations
    end

    def specificity
      a = b = c = 0
      simple_selectors.each do |s|
        if s.is_a?(Selectors::Type) && s.name && s.name != ''
          c += 1
        end
        s.additional_selectors.each do |additional_selector|
          case additional_selector
          when Selectors::Id
            a += 1
          when Selectors::PseudoElement
            c += 1
          when Selectors::Class, Selectors::PseudoClass, Selectors::Attribute
            b += 1
          end
        end
      end
      [a, b, c]
    end
  end
end
