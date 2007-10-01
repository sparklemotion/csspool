module CSS
  module SAC
    class LexicalUnit
      attr_accessor :dimension_unit_text,
                    :lexical_unit_type,
                    :float_value,
                    :integer_value,
                    :string_value,
                    :parameters

      alias :to_s :string_value
    end

    class LexicalColor < LexicalUnit
      def initialize(value)
        self.string_value = value
        self.lexical_unit_type = :SAC_RGBCOLOR
        if value =~ /^#(\d{1,2})(\d{1,2})(\d{1,2})$/
          self.parameters = [
            Number.new($1.hex, '', :SAC_INTEGER),
            Number.new($2.hex, '', :SAC_INTEGER),
            Number.new($3.hex, '', :SAC_INTEGER)
          ]
        else
          self.parameters = [LexicalIdent.new(value)]
        end
      end
    end

    class LexicalString < LexicalUnit
      def initialize(value)
        self.string_value = value
        self.lexical_unit_type = :SAC_STRING_VALUE
      end
    end

    class LexicalIdent < LexicalUnit
      def initialize(value)
        self.string_value = value
        self.lexical_unit_type = :SAC_IDENT
      end
    end

    class LexicalURI < LexicalUnit
      def initialize(value)
        self.string_value = value.gsub(/^url\(/, '').gsub(/\)$/, '')
        self.lexical_unit_type = :SAC_URI
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
        '%'     => :SAC_PERCENTAGE,
        'em'    => :SAC_EM,
        'ex'    => :SAC_EX,
      }
      def initialize(value, unit = nil, type = nil)
        if value.is_a?(String)
          value =~ /^([0-9.]*)(.*)$/
          value = $1
          unit  ||= $2
        end
        type  ||= UNITS[self.dimension_unit_text]
        self.string_value = "#{value}#{unit}"
        self.float_value = value.to_f
        self.integer_value = value.to_i
        self.dimension_unit_text = unit.downcase
        self.lexical_unit_type = UNITS[self.dimension_unit_text]
      end
    end
  end
end
