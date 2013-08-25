module CSSPool
  module Terms
    class Resolution < CSSPool::Node
      attr_accessor :number, :unit, :parse_location

      def initialize(number, unit, parse_location = {})
        @number = number
        @unit = unit
        @parse_location = parse_location
      end
    end
  end
end
