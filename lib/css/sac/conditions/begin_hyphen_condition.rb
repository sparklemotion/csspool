require "css/sac/conditions"

module CSS
  module SAC
    module Conditions
      class BeginHyphenCondition < AttributeCondition
        
        def initialize(local_name, value)
          super(local_name, value, true, :SAC_BEGIN_HYPHEN_ATTRIBUTE_CONDITION)
        end
        
        def to_css
          "[#{local_name}|=#{value}]"
        end

        def to_xpath
          "[contains(@#{local_name}, '#{value}')]"
        end
      end
    end
  end
end
