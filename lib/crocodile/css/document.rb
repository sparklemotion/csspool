module Crocodile
  module CSS
    class Document
      include Crocodile::Visitable

      def self.parse string
        unless string && string.length > 0
          return Crocodile::CSS::Document.new
        end
        handler = Crocodile::CSS::DocumentHandler.new
        parser = Crocodile::SAC::Parser.new(handler)
        parser.parse(string)
        handler.document
      end

      attr_accessor :rule_sets
      attr_accessor :charsets
      attr_accessor :import_rules

      def initialize
        @rule_sets    = []
        @charsets     = []
        @import_rules = []
      end
    end
  end
end
