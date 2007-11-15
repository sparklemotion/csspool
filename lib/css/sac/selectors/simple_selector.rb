require "css/sac/selectors"

module CSS
  module SAC
    module Selectors
      class SimpleSelector < Selector
        def initialize(selector_type=:SAC_ANY_NODE_SELECTOR)
          super(selector_type)
        end

        def to_css
          '*'
        end

        def to_xpath
          "//*"
        end

        def specificity
          0
        end
      end
    end
  end
end
