module CSS
  module SAC
    class LexicalUnit
      attr_accessor :dimension_unit_text,
                    :lexical_unit_type,
                    :float_value,
                    :integer_value
      def initialize(value, unit, type)
        self.float_value = value.to_f
        self.integer_value = value.to_i
        self.dimension_unit_text = unit.downcase
        self.lexical_unit_type = type
      end
    end

    class Number < LexicalUnit
      NON_NEGATIVE_UNITS = [
        :SAC_DEGREE,
        :SAC_GRADIAN,
        :SAC_RADIAN,
        :SAC_MILLISECOND,
        :SAC_SECOND,
        :SAC_HERTZ,
        :SAC_KILOHERTZ,
      ]
      UNITS = {
        'deg'   => :SAC_PIXEL,
        'rad'   => :SAC_CENTEMETER,
        'grad'  => :SAC_MILLIMETER,
        'ms'    => :SAC_MILLISECOND,
        's'     => :SAC_SECOND,
        'hz'    => :SAC_HERTZ,
        'khz'   => :SAC_KILOHERTZ,
        'px'    => :SAC_PIXEL,
        'cm'    => :SAC_CENTEMETER,
        'mm'    => :SAC_MILLIMETER,
        'in'    => :SAC_INCH,
        'pt'    => :SAC_POINT,
        'pc'    => :SAC_PICA,
      }
      def initialize(value)
        value =~ /^([0-9.]*)(.*)$/
        super($1.to_f, $2, UNITS[$2.downcase])
      end
    end
  end
end
