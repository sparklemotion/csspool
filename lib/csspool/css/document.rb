module CSSPool
  module CSS
    class Document < Node
      def self.parse string
        unless string && string.length > 0
          return CSSPool::CSS::Document.new
        end
        handler = CSSPool::CSS::DocumentHandler.new
        parser = CSSPool::SAC::Parser.new(handler)
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
    end
  end
end
