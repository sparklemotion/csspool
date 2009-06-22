module Crocodile
  module Terms
    class Number < Ident
      attr_accessor :type

      def initialize type, value, operator, parse_location
        @type = type
        super(value, operator, parse_location)
      end

      def to_s
        units = {
          2   => 'em',
          3   => 'ex',
          4   => 'px',
          5   => 'in',
          6   => 'cm',
          7   => 'mm',
          8   => 'pt',
          9   => 'pc',
          10  => 'deg',
          11  => 'rad',
          12  => 'grad',
          13  => 'ms',
          14  => 's',
          15  => 'Hz',
          16  => 'kHz',
          17  => '%',
        }[type]
        [operator == :minus ? '-' : nil, value, units].compact.join
      end
    end
  end
end
