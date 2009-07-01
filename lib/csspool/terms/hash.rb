module CSSPool
  module Terms
    class Hash < CSSPool::Node
      attr_accessor :value
      attr_accessor :parse_location

      def initialize value, parse_location
        @value = value
        @parse_location = parse_location
      end
    end
  end
end
