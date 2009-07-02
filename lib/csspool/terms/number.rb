module CSSPool
  module Terms
    class Number < Ident
      attr_accessor :type
      attr_accessor :unary_operator

      def initialize type, unary_operator, value, operator, parse_location
        @type     = type
        @unary_operator = unary_operator
        super(value, operator, parse_location)
      end
    end
  end
end
