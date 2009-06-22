module Crocodile
  module Terms
    class Number < Ident
      attr_accessor :type

      def initialize type, value, operator, parse_location
        @type = type
        super(value, operator, parse_location)
      end
    end
  end
end
