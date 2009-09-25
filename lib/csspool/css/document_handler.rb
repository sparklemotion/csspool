module CSSPool
  module CSS
    class DocumentHandler < CSSPool::SAC::Document
      attr_accessor :document

      def initialize
        @document     = nil
        @media_stack  = []
      end

      def start_document
        @document = CSSPool::CSS::Document.new
      end

      def charset name, location
        @document.charsets << CSS::Charset.new(name, location)
      end

      def import_style media_list, uri, ns = nil, loc = {}
        @document.import_rules << CSS::ImportRule.new(
          uri,
          ns,
          media_list.map { |x| CSS::Media.new(x, loc) },
          @document,
          loc
        )
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

      def start_media media_list, parse_location = {}
        @media_stack << media_list.map { |x| CSS::Media.new(x, parse_location) }
      end

      def end_media media_list, parse_location = {}
        @media_stack.pop
      end
    end
  end
end
