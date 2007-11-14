module CSS
  module SAC
    module Selectors
      class Selector
        attr_reader :selector_type
        
        def initialize(selector_type)
          @selector_type = selector_type
        end

        def ==(other)
          self.class === other && selector_type == other.selector_type
        end
      end
    end
  end
end
