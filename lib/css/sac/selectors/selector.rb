module CSS
  module SAC
    module Selectors
      class Selector
        include CSS::SAC::Visitable

        attr_reader :selector_type
        
        def initialize(selector_type)
          @selector_type = selector_type
        end

        def ==(other)
          self.class === other && selector_type == other.selector_type
        end

        def eql?(other)
          self == other
        end
        
        def =~(node)
          MatchesVisitor.new(node).accept(self)
        end
      end
    end
  end
end
