module CSS
  module SAC
    module Selectors
      class Selector
        attr_reader :selector_type
        
        def initialize(selector_type)
          @selector_type = selector_type
        end
      end
    end
  end
end
