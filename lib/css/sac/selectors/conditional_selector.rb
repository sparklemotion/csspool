require "css/sac/selectors"

module CSS
  module SAC
    module Selectors
      class ConditionalSelector < SimpleSelector
        attr_accessor :condition, :simple_selector
        alias :selector :simple_selector

        def initialize(selector, condition)
          super(:SAC_CONDITIONAL_SELECTOR)

          @condition = condition
          @simple_selector = selector
        end

        def to_css
          [selector, condition].map { |x|
            x ? x.to_css : ''
          }.join('')
        end

        def to_xpath(prefix=true)
          atoms = []
          atoms << "//" if prefix
          atoms << (selector ? selector.to_xpath(false) : "*")
          atoms << condition.to_xpath

          atoms.join("")
        end

        def specificity
          (selector ? selector.specificity : 0) +
            (condition ? condition.specificity : 0)
        end

        def ==(other)
          super && condition == other.condition && selector == other.selector
        end

        def hash
          [condition, selector].hash
        end
      end
    end
  end
end
