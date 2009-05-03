module Crocodile
  module SAC
    class Parser
      attr_accessor :document

      def initialize document = Crocodile::SAC::Document.new
        @document = document
      end

      def parse string
        parse_memory(string, 5)
      end
    end
  end
end
