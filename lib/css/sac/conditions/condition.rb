module CSS
  module SAC
    module Conditions
      class Condition
        include CSS::SAC::Visitable

        attr_accessor :condition_type
        
        def initialize(condition_type)
          @condition_type = condition_type
        end

        def ==(other)
          self.class === other && condition_type == other.condition_type
        end

        def hash
          condition_type.hash
        end

        def eql?(other)
          self == other
        end

        def to_css
          nil
        end

        def =~(node)
          MatchesVisitor.new(node).accept(self)
        end
      end
    end
  end
end
