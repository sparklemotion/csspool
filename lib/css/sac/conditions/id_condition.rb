require "css/sac/conditions"

module CSS
  module SAC
    module Conditions
      class IDCondition < AttributeCondition
        
        def initialize(id)
          id = id[1..id.size] if id[0] == ?#
          super("id", id, true, :SAC_ID_CONDITION)
        end
        
        def to_css
          "##{value}"
        end

        def to_xpath
          "[@id='#{value}']"
        end

        def specificity
          [0, 1, 0, 0]
        end
      end
    end
  end
end
