module CSSPool
  module SAC
    class Parser < CSSPool::CSS::Tokenizer
      attr_accessor :handler

      def initialize handler = CSSPool::CSS::DocumentHandler.new
        @handler = handler
      end

      def parse string
        scan_str string
        @handler.document
      end
    end
  end
end
