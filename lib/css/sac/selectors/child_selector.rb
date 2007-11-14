require "css/sac/selectors"

module CSS
  module SAC
    module Selectors
      class ChildSelector < SimpleSelector
        attr_accessor :ancestor_selector, :simple_selector
        alias :parent :ancestor_selector
        alias :selector :simple_selector

        def initialize(parent, selector)
          super(:SAC_CHILD_SELECTOR)
          
          @ancestor_selector = parent
          @simple_selector = selector
        end

        def to_css
          "#{parent.to_css} > #{selector.to_css}"
        end

        def to_xpath(prefix=true)
          "#{parent.to_xpath(prefix)}/#{selector.to_xpath(false)}"
        end

        def specificity
          parent.specificity + selector.specificity
        end

        def ==(other)
          super && parent == other.parent && selector == other.selector
        end
      end
    end
  end
end
