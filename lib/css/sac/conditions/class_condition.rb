require "css/sac/conditions"

module CSS
  module SAC
    module Conditions
      class ClassCondition < AttributeCondition
        
        def initialize(klass)
          super("class", klass, true, :SAC_CLASS_CONDITION)
        end
        
        def to_css
          ".#{value}"
        end

        def to_xpath
          "[contains(@#{local_name}, '#{value}')]"
        end
      end
    end
  end
end
