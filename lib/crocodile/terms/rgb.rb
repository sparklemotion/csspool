module Crocodile
  module Terms
    class Rgb < Crocodile::Node
      attr_accessor :red
      attr_accessor :green
      attr_accessor :blue
      attr_accessor :percentage
      attr_accessor :parse_location
      alias :percentage? :percentage

      def initialize red, green, blue, percentage, parse_location
        super()
        @red    = red
        @green  = green
        @blue   = blue
        @percentage = percentage
        @parse_location = parse_location
      end
    end
  end
end
