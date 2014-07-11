# Represents an @font-face rule
module CSSPool
  module CSS
    class FontfaceRule < CSSPool::Node

      attr_accessor :declarations

      def initialize
        @declarations = []
      end
    end
  end
end
