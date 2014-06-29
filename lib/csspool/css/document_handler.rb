module CSSPool
  module CSS
    class DocumentHandler < CSSPool::SAC::Document
      attr_accessor :document
      attr_accessor :node_start_pos

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
          @conditional_stack.last
        )
        @document.rule_sets << rs
        @conditional_stack.last.rule_sets << rs unless @conditional_stack.empty?
      end

      def property declaration
        rs = @active_keyframes_block.nil? ? @document.rule_sets.last : @active_keyframes_block
        declaration.rule_set = rs
        rs.declarations << declaration
      end

      def start_media media_query_list
        @conditional_stack << media_query_list
      end

      def end_media media_query_list
        @conditional_stack.pop
      end

      def start_document_query url_functions, inner_start_pos = nil
        dq = CSS::DocumentQuery.new(url_functions)
        dq.outer_start_pos = @node_start_pos
        @node_start_pos = nil
        dq.inner_start_pos = inner_start_pos
        @document.document_queries << dq
        @conditional_stack << dq
      end

      def end_document_query inner_end_pos = nil, outer_end_pos = nil
        last = @conditional_stack.pop
        last.inner_end_pos = inner_end_pos
        last.outer_end_pos = outer_end_pos
      end
      
      def start_supports conditions
        sr = CSS::SupportsRule.new(conditions)
        @document.supports_rules << sr
        @conditional_stack << sr
      end

      def end_supports
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
