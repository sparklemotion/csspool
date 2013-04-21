# http://dev.w3.org/csswg/css3-values/#calc-notation
module CSSPool
  module Terms
    class Math < CSSPool::Node
      attr_accessor :name
      attr_accessor :expression
      attr_accessor :operator
      attr_accessor :parse_location

      def initialize name, expression, operator = nil, parse_location = {}
        @name       = name
        @expression = expression
        @operator = operator
        @parse_location = parse_location
      end
    end
  end
end
