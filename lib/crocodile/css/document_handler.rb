module Crocodile
  module CSS
    class DocumentHandler < Crocodile::SAC::Document
      attr_accessor :document

      def initialize
        @document     = nil
        @media_stack  = []
      end

      def start_document
        @document = Crocodile::CSS::Document.new
      end

      def charset name, location
        @document.charset = name
      end

      def start_selector selector_list
        @document.rule_sets << RuleSet.new(
          selector_list,
          [],
          @media_stack.last || []
        )
      end

      def property name, exp, important
        rs = @document.rule_sets.last
        rs.declarations << Declaration.new(name, exp, important, rs)
      end

      def start_media media_list
        @media_stack << media_list
      end

      def end_media media_list
        @media_stack.pop
      end
    end
  end
end
