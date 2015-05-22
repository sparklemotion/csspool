module CSSPool
  module Terms
    class Ratio < Ident
      attr_accessor :numerator
      attr_accessor :denominator

      def initialize numerator, denominator, parse_location = {}
        @numerator = numerator
        @denominator = denominator
        super(value, operator, parse_location)
      end
    end
  end
end
