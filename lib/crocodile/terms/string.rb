module Crocodile
  module Terms
    class String < Crocodile::Node
      attr_accessor :value
      attr_accessor :parse_location

      def initialize value, parse_location
        @value = value
        @parse_location = parse_location
      end

      def to_css
        "\"#{value}\""
      end
    end
  end
end
