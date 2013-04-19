# Represents an @keyframes rule
module CSSPool
  module CSS
    class KeyframesRule < CSSPool::Node
      attr_accessor :name
      attr_accessor :rule_sets

      def initialize name
        @name = name
        @rule_sets = []
      end
    end
  end
end
