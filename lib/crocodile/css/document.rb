module Crocodile
  module CSS
    class Document
      def self.parse string
        handler = Crocodile::CSS::DocumentHandler.new
        parser = Crocodile::SAC::Parser.new(handler)
        parser.parse(string)
        handler.document
      end

      attr_accessor :rule_sets
      attr_accessor :charset
      def initialize
        @rule_sets  = []
        @charset    = nil
      end
    end
  end
end
