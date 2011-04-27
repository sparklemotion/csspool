module CSSPool
  module SAC
    class Parser < CSSPool::CSS::Tokenizer
      attr_accessor :document

      def initialize document = CSSPool::SAC::Document.new
        @document = document
      end

      alias :parse :scan_str
    end
  end
end
