# Represents an @document conditional rule
module CSSPool
  module CSS
    class DocumentQuery < CSSPool::Node
      attr_accessor :url_functions

      def initialize url_functions
        @url_functions = url_functions
      end
    end
  end
end
