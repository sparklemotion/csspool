module CSS
  module SAC
    class LexicalUnit
      attr_accessor :dimension_unit_text,
                    :lexical_unit_type,
                    :float_value,
                    :integer_value,
                    :string_value,
                    :parameters,
                    :function_name

      def ==(other)
        self.class === other && self.lexical_unit_type == other.lexical_unit_type
      end

      def eql?(other)
        self == other
      end

      alias :to_s :string_value
    end

    class Function < LexicalUnit
      FUNCTIONS = {
        'counter'   => :SAC_COUNTER_FUNCTION,
        'counters'  => :SAC_COUNTERS_FUNCTION,
        'rect'      => :SAC_RECT_FUNCTION,
      }
      def initialize(name, params)
        self.string_value = "#{name}#{params.join(', ')})"
        name =~ /^(.*)\(/
        self.function_name = $1
        self.parameters = params
        self.lexical_unit_type = FUNCTIONS[self.function_name] || :SAC_FUNCTION
      end

      def ==(other)
        super && %w{ function_name parameters }.all? { |x|
          self.send(x.to_sym) == other.send(x.to_sym)
        }
      end

      def hash
        ([self.function_name] + parameters).hash
      end
    end

    class Color < LexicalUnit
      def initialize(value)
        self.string_value = value
        self.lexical_unit_type = :SAC_RGBCOLOR
        if value =~ /^#([A-F\d]{1,2})([A-F\d]{1,2})([A-F\d]{1,2})$/
          self.parameters = [$1, $2, $3].map { |x|
            x.length == 1 ? (x * 2).hex : x.hex
          }.map { |x|
            Number.new(x, '', :SAC_INTEGER)
          }
        else
          self.parameters = [LexicalIdent.new(value)]
        end
      end

      def ==(other)
        super && self.parameters == other.parameters
      end

      def hash
        self.parameters.hash
      end

      def to_s
        if self.parameters.length < 3
          super
        else
          hex = self.parameters.map { |x|
            sprintf("%02X", x.integer_value).split('').uniq
          }.flatten
          hex.length != 3 ? super : "##{hex.join()}"
        end
      end
    end

    class LexicalString < LexicalUnit
      def initialize(value)
        self.string_value = value
        self.lexical_unit_type = :SAC_STRING_VALUE
      end

      def ==(other)
        super && self.string_value == other.string_value
      end

      def hash
        self.string_value.hash
      end
    end

    class LexicalIdent < LexicalUnit
      def initialize(value)
        self.string_value = value
        self.lexical_unit_type = :SAC_IDENT
      end

      def ==(other)
        super && self.string_value == other.string_value
      end

      def hash
        self.string_value.hash
      end
    end

    class LexicalURI < LexicalUnit
      def initialize(value)
        self.string_value = value.gsub(/^url\(/, '').gsub(/\)$/, '')
        self.lexical_unit_type = :SAC_URI
      end

      def ==(other)
        super && self.string_value == other.string_value
      end

      def hash
        self.string_value.hash
      end

      def to_s
        "url(#{string_value})"
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
        'deg'   => :SAC_DEGREE,
        'rad'   => :SAC_RADIAN,
        'grad'  => :SAC_GRADIAN,
        'ms'    => :SAC_MILLISECOND,
        's'     => :SAC_SECOND,
        'hz'    => :SAC_HERTZ,
        'khz'   => :SAC_KILOHERTZ,
        'px'    => :SAC_PIXEL,
        'cm'    => :SAC_CENTIMETER,
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
          value =~ /^(-?[0-9.]*)(.*)$/
          value = $1
          unit  ||= $2
        end
        type  ||= UNITS[self.dimension_unit_text]
        self.string_value = "#{value}#{unit}"
        self.float_value = value.to_f
        self.integer_value = value.to_i
        self.dimension_unit_text = unit.downcase
        self.lexical_unit_type = UNITS[self.dimension_unit_text] ||
          (value =~ /\./ ? :SAC_NUMBER : :SAC_INTEGER)
      end

      def ==(other)
        return true if self.float_value == 0 && other.float_value == 0
        return false unless super
        
        %w{ float_value integer_value dimension_unit_text }.all? { |x|
          self.send(x.to_sym) == other.send(x.to_sym)
        }
      end

      def hash
        if self.float_value == 0
          self.float_value.hash
        else
          %w{ float_value integer_value dimension_unit_text }.map { |x|
            self.send(x.to_sym)
          }.hash
        end
      end

      def to_s
        if self.float_value == 0
          "0"
        else
          super
        end
      end
    end
  end
end
