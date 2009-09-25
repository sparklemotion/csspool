module CSSPool
  module Terms
    class Rgb < CSSPool::Node
      attr_accessor :red
      attr_accessor :green
      attr_accessor :blue
      attr_accessor :parse_location
      attr_accessor :operator

      def initialize red, green, blue, operator = nil, parse_location = {}
        super()
        @red    = red
        @green  = green
        @blue   = blue
        @operator = operator
        @parse_location = parse_location
      end
    end
  end
end
