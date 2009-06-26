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
      attr_accessor :parent
      attr_accessor :parent_import_rule

      def initialize
        @rule_sets    = []
        @charsets     = []
        @import_rules = []
        @parent       = nil
        @parent_import_rule = nil
      end

      def apply_to doc
        rule_sets.each do |rs|
          rs.selectors.each do |sel|
            doc.css(sel.to_css).each do |node|
              node.selectors << sel
            end
          end
        end
      end
    end
  end
end
