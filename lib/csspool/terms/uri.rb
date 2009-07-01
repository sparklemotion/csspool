module CSSPool
  module Terms
    class URI < CSSPool::Node
      attr_accessor :value, :parse_location
      def initialize value, parse_location
        @value = value
        @parse_location = parse_location
      end
    end
  end
end
