# Represents an @document conditional rule
module CSSPool
  module CSS
    class DocumentQuery < CSSPool::Node
      attr_accessor :url_functions
      attr_accessor :rule_sets

      def initialize url_functions
        @url_functions = url_functions
        @rule_sets = []
      end
    end
  end
end
