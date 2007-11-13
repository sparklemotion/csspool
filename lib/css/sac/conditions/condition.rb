module CSS
  module SAC
    module Conditions
      class Condition
        attr_accessor :condition_type
        
        def initialize(condition_type)
          @condition_type = condition_type
        end
      end
    end
  end
end
