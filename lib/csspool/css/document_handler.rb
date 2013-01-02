module CSSPool
  module CSS
    class DocumentHandler < CSSPool::SAC::Document
      attr_accessor :document

      def initialize
        @document     = nil
        @conditional_stack  = []
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
          @conditional_stack.last || []
        )
      end

      def property name, exp, important
        rs = @document.rule_sets.last
        rs.declarations << Declaration.new(name, exp, important, rs)
      end

      def start_media media_list, parse_location = {}
        @conditional_stack << media_list.map { |x| CSS::Media.new(x, parse_location) }
      end

      def end_media media_list, parse_location = {}
        @conditional_stack.pop
      end

      def start_document_query url_functions
        dq = CSS::DocumentQuery.new(url_functions)
        @document.document_queries << dq
        @conditional_stack << dq
      end

      def end_document_query
        @conditional_stack.pop
      end

    end
  end
end
