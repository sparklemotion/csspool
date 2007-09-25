require 'css/sac' # FIXME

module CSS
  class SAC # FIXME
    class Token
      attr_reader :name, :value, :position
      
      def initialize(name, value, position)
        @name = name
        @value = value
        @position = position
      end

      def to_racc_token
        [name, value]
      end
    end
    
    class DelimiterToken < Token
      def initialize(value, position)
        super(:delim, value, position)
      end
      
      def to_racc_token
        [value, value]
      end
    end  
  end
end
