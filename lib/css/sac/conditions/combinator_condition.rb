require "css/sac/conditions"

module CSS
  module SAC
    module Conditions
      class CombinatorCondition < Condition
        attr_accessor :first_condition, :second_condition
        alias :first :first_condition
        alias :second :second_condition

        def initialize(first, second)
          super(:SAC_AND_CONDITION)
          
          @first_condition = first
          @second_condition = second
        end

        def to_css
          "#{first.to_css}#{second.to_css}"
        end

        def to_xpath
          "#{first.to_xpath}#{second.to_xpath}"        
        end

        def specificity
          first.specificity + second.specificity
        end
      end
    end
  end
end
