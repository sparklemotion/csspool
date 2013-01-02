module CSSPool
  module CSS
    class Document < Node
      def self.parse string
        # If a File object gets passed in, via functions like File.open
        # or Kernel::open
        if string.respond_to? :read
          string = string.read
        end

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
      attr_accessor :namespaces
      attr_accessor :parent
      attr_accessor :parent_import_rule

      def initialize
        @rule_sets    = []
        @charsets     = []
        @import_rules = []
        @namespaces   = []
        @parent       = nil
        @parent_import_rule = nil
      end

      def [] selector
        selectors = CSSPool.CSS("#{selector} {}").rule_sets.first.selectors
        rule_sets.find_all { |rs| rs.selectors == selectors}
      end
    end
  end
end
