module CSS
  module SAC
    module Conditions
      class Condition
        attr_accessor :condition_type
        
        def initialize(condition_type)
          @condition_type = condition_type
        end

        def ==(other)
          self.class === other && condition_type == other.condition_type
        end
      end
    end
  end
end
