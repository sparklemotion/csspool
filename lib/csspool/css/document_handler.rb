module CSSPool
  module CSS
    class DocumentHandler < CSSPool::SAC::Document
      attr_accessor :document

      def initialize
        @document     = nil
        @conditional_stack  = []
        @active_keyframes_block = nil
      end

      def start_document
        @document = CSSPool::CSS::Document.new
      end

      def charset name, location
        @document.charsets << CSS::Charset.new(name, location)
      end

      def import_style media, uri, ns = nil, loc = {}
        @document.import_rules << CSS::ImportRule.new(
          uri,
          ns,
          media,
          @document,
          loc
        )
      end

      def namespace prefix, uri
        @document.namespaces << CSS::NamespaceRule.new(
          prefix,
          uri
        )
      end

      def start_selector selector_list
        rs = RuleSet.new(
          selector_list,
          [],
          @conditional_stack.last || []
        )
        @document.rule_sets << rs
        @conditional_stack.last.rule_sets << rs unless @conditional_stack.empty?
      end

      def property name, exp, important
        rs = @active_keyframes_block.nil? ? @document.rule_sets.last : @active_keyframes_block
        rs.declarations << Declaration.new(name, exp, important, rs)
      end

      def start_media media_query_list, parse_location = {}
        @conditional_stack << media_query_list
      end

      def end_media media_query_list, parse_location = {}
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

      def start_keyframes_rule name
        @document.keyframes_rules << CSS::KeyframesRule.new(name)
      end

      def start_keyframes_block keyText
        @active_keyframes_block = CSS::KeyframesBlock.new(keyText)
        @document.keyframes_rules.last.rule_sets << @active_keyframes_block
      end

      def end_keyframes_block
        @active_keyframes_block = nil
      end

    end
  end
end
