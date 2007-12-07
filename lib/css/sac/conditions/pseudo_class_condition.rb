require "css/sac/conditions"

module CSS
  module SAC
    module Conditions
      class PseudoClassCondition < AttributeCondition
        def initialize(pseudo_class)
          super(nil, pseudo_class, false, :SAC_PSEUDO_CLASS_CONDITION)
        end
        
        def to_css
          ":#{value}"
        end
        
        def to_xpath
        end

        def specificity
          [0, 0, 0, 0]
        end
      end
    end
  end
end
