module Crocodile
  module CSS
    class DocumentHandler < Crocodile::SAC::Document
      attr_accessor :document

      def initialize
        @document = nil
      end

      def start_document
        @document = Crocodile::CSS::Document.new
      end

      def charset name, location
        @document.charset = name
      end

      def start_selector selector_list
        @document.rule_sets << RuleSet.new(selector_list)
      end

      def property name, exp, important
        @document.rule_sets.last.declarations <<
          Declaration.new(name, exp, important)
      end
    end
  end
end
