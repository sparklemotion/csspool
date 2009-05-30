module Crocodile
  module SAC
    class Parser
      attr_accessor :document

      def initialize document = Crocodile::SAC::Document.new
        @document = document
        @selector_stack = []
      end

      def parse string
        parse_memory(string, 5)
      end

      private
      def push selectors
        @selector_stack << selectors
      end

      def pop
        @selector_stack.pop
      end
    end
  end
end
