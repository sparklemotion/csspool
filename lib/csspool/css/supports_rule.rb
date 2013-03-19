# Represents an @supports conditional rule
module CSSPool
  module CSS
    class SupportsRule < CSSPool::Node
      attr_accessor :conditions
      attr_accessor :rule_sets

      def initialize conditions
        @conditions = conditions
        @rule_sets = []
      end
    end
  end
end
