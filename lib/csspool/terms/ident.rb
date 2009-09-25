module CSSPool
  module Terms
    class Ident < CSSPool::Node
      attr_accessor :value
      attr_accessor :operator
      attr_accessor :parse_location

      def initialize value, operator = nil, parse_location = {}
        @value = value
        @operator = operator
        @parse_location = parse_location
      end
    end
  end
end
