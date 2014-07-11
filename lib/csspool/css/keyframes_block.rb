# Represents a block inside a @keyframes rule
module CSSPool
  module CSS
    class KeyframesBlock < CSSPool::Node
      attr_accessor :keyText
      attr_accessor :declarations

      def initialize keyText
        @keyText = keyText
        @declarations = []
      end
    end
  end
end
