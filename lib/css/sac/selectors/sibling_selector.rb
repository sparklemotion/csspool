require "css/sac/selectors"

module CSS
  module SAC
    module Selectors
      class SiblingSelector < SimpleSelector
        attr_accessor :selector, :sibling_selector
        alias :sibling :sibling_selector
        
        def initialize(selector, sibling)
          super(:SAC_DIRECT_ADJACENT_SELECTOR)
          
          @selector = selector
          @sibling_selector = sibling
        end

        def to_css
          "#{selector.to_css} + #{sibling.to_css}"
        end

        def to_xpath(prefix=true)
          "#{selector.to_xpath(prefix)}/following-sibling::#{sibling.to_xpath(false)}"
        end

        def specificity
          selector.specificity + sibling.specificity
        end
      end
    end
  end
end
