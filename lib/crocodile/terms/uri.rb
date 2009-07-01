module Crocodile
  module Terms
    class URI < Crocodile::Node
      attr_accessor :value, :parse_location
      def initialize value, parse_location
        @value = value
        @parse_location = parse_location
      end
    end
  end
end
