module Crocodile
  module Terms
    class Hash < Crocodile::Node
      attr_accessor :value
      attr_accessor :parse_location

      def initialize value, parse_location
        @value = value
        @parse_location = parse_location
      end
    end
  end
end
